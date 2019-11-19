//
//  ExportClient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/17/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine

enum ExportError: Error {
    case inProgress
}

class ExportClient {
    
    private let defaultURLSession: URLSession
    private let baseURL: String

    private var exportCancel: AnyCancellable?
    private var backGroundQueue: DispatchQueue
    private var activeDownloads: [URL: ExportDownload] = [:]
    
    init(with: String) {
        self.defaultURLSession = ExportClient.buildSession()
        self.baseURL = with
        self.backGroundQueue = DispatchQueue(label: "DPCExplorer")
    }
    
    public func exportData(groupID: UUID) {
        exportCancel?.cancel()
        
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
                    debugPrint("Line:", line)
                }
            }
            export.task?.resume()
            export.isDownloading = true
            self.activeDownloads[output.url] = export
        }
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
