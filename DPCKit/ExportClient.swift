//
//  ExportClient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/17/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine
import FHIR
import CoreData
import Compression

enum ExportError: Error {
    case inProgress
}

class ExportClient {
    
    private let defaultURLSession: URLSession
    private let baseURL: String
    private let provider: ProviderEntity
    private let context: NSManagedObjectContext
    
    private var exportCancel: AnyCancellable?
    private var backGroundQueue: DispatchQueue
    private var activeDownloads: [URL: ExportDownload] = [:]
    
    init(with: String, provider: ProviderEntity, context: NSManagedObjectContext) {
        self.defaultURLSession = ExportClient.buildSession()
        self.baseURL = with
        self.backGroundQueue = DispatchQueue(label: "DPCExplorer")
        self.provider = provider
        self.context = context
    }
    
    public func exportData() {
        exportCancel?.cancel()
        
        guard let groupID = self.provider.rosterID else {
            debugPrint("No roster, nothing to export")
            return
        }
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 3002
        components.path = "/v1/Group/\(groupID)/$export"
        
        // /\(groupID.uuidString.lowercased())/$export
        
        do {
            let u = try components.asURL()
            debugPrint(u)
        } catch let error {
            debugPrint(error)
        }
        
        let url = components.url!
        
        var request = URLRequest(url: url)
        request.setValue("respond-async", forHTTPHeaderField: "Prefer")
        request.setValue("application/fhir+json", forHTTPHeaderField: "Accept")
        
        self.exportCancel = self.defaultURLSession.dataTaskPublisher(for: request)
            .tryMap{ data, response -> URL in
                guard let httpResponse  = response as? HTTPURLResponse,
                    httpResponse.statusCode == 202 else {
                        fatalError("Did not export correctly")
                }
                guard let location = httpResponse.headers["Content-Location"],
                    let jobURL = URL(string: location) else {
                        fatalError("Could not convert to URL")
                }
                return jobURL
        }
        .flatMap(self.monitorExportJob)
        .decode(type: JobCompletionModel.self, decoder: JSONDecoder())
        .sink(receiveCompletion: {completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                debugPrint("Received an error: ", error)
            }
        }, receiveValue: self.downloadFiles)
    }
    
    private func downloadFiles(model: JobCompletionModel) -> Void {
        debugPrint("Completed mode:", model)
        
        model.output.forEach{ output in
            
            guard output.type == "ExplanationOfBenefit" else {
                return
            }
            
            let export = ExportDownload(output: output)
            
            export.task = self.defaultURLSession.downloadTask(with: output.url) { url, response, error in
                guard let url = url else {
                    return
                }
                let download = self.activeDownloads[url]
                self.activeDownloads[url] = nil
                download?.isDownloading = false
                
                // Don't do this here
                let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
                debugPrint("Copying from \(url) to \(destinationUrl)")
                do {
                    try FileManager.default.copyItem(at: url, to: destinationUrl)
                } catch {
                    debugPrint("Could not copy", error)
                    return
                }
                
                debugPrint("File:", destinationUrl.absoluteString)
                
                guard let reader = StreamReader(path: destinationUrl.path) else {
                    debugPrint("Cannot open file")
                    return
                }
                
                for line in reader {
                    // Each line is an EOB, so parse it up
                    // Gross
                    let data = line.data(using: .utf8)
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? FHIRJSON
                    
                    // Disable validation, because we have custom extensions
                    var ctx = FHIRInstantiationContext(strict: false)
                    let eob = FHIR.ExplanationOfBenefit.init(json: json!, context: &ctx)
                    
                    // Extract the patient ID
                    debugPrint("Ref:", eob.patient ?? "")
                    guard let patientReference = eob.patient?.reference else {
                        return
                    }
                    
                    let split = patientReference.string.components(separatedBy: "/")
                    // Get the patient ID
                    let patientID = split[1]
                    
                    // Split out the type and id
                    
                    // Create a new background app context to do everything
                    self.context.performAndWait {
                        
                        let req = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
                        req.predicate = NSPredicate(format: "ANY identifierRelationship.value = %@ AND identifierRelationship.@count = 1", patientID)
                        let fetchedPatient = try! self.context.fetch(req)
                        guard !fetchedPatient.isEmpty else {
                            debugPrint("Could not find patient")
                            return
                        }
                        debugPrint("Found patient:", fetchedPatient[0])
                        
                        
                        // Going back and forth is terrible
                        // Compress it, because, why not?
                        let compressed = self.compressData(input: line.data(using: .utf8))
                        let pEOB = EOBEntity(context: self.context)
                        pEOB.eob = compressed
                        
                        fetchedPatient[0].addToEobs(pEOB)
                        
                        do {
                            try self.context.save()
                        } catch {
                            debugPrint("Error saving context", error)
                        }
                        debugPrint("Done")
                    }
                }
            }
            export.task?.resume()
            export.isDownloading = true
            self.activeDownloads[output.url] = export
        }
    }
    
    private func compressData(input: Data?) -> Data? {
        guard input != nil else {
            return nil
        }
        
        let pageSize = 128
        debugPrint("Pre-compression:", input?.count ?? 0)
        var compressed = Data()
        do {
            let outputFilter = try OutputFilter(.compress, using: .lzfse) {
                (data: Data?) -> Void in
                if let data = data {
                    compressed.append(data)
                }
            }
            
            var index = 0
            let bufferSize = input!.count
            
            while true {
                let rangeLength = min(pageSize, bufferSize - index)
                
                let subdata = input!.subdata(in: index ..< index + rangeLength)
                index += rangeLength
                
                try outputFilter.write(subdata)
                
                if (rangeLength == 0) {
                    break
                }
            }
        } catch {
            debugPrint("Could not compress:", error)
            return nil
        }
        debugPrint("Compressed size:", compressed.count)
        
        return compressed
    }
    
    private func monitorExportJob(jobURL: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: jobURL)
        request.setValue("respond-async", forHTTPHeaderField: "Prefer")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return self.defaultURLSession.dataTaskPublisher(for: request)
            .tryMap{data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    debugPrint(response)
                    fatalError("Could not get HTTP Response")
                }
                
                // If it's accepted, throw an error, this is gross, but should work?
                if (httpResponse.statusCode == 202) {
                    debugPrint("In progress, continuing")
                    throw ExportError.inProgress
                } else if (httpResponse.statusCode == 200) {
                    debugPrint("We're done", httpResponse)
                    return data
                } else {
                    debugPrint(response)
                    fatalError("Something else went wrong")
                }
        }
        .delay(for: 2, scheduler: self.backGroundQueue)
        .retry(.max)
        .subscribe(on: self.backGroundQueue)
        .eraseToAnyPublisher()
    }
    
    private static func buildSession() -> URLSession {
        return URLSession(configuration: .default)
    }
}
