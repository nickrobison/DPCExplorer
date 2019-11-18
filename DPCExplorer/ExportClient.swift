//
//  ExportClient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/17/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Combine

class ExportClient {
    
    private let defaultURLSession: URLSession
    private let baseURL: String

    private var exportCancel: AnyCancellable?
    
    init(with: String) {
        self.defaultURLSession = ExportClient.buildSession()
        self.baseURL = with
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
        .sink(receiveCompletion: {completion in
            debugPrint("Received completion", completion)
            switch completion {
            case .finished:
                break
            case .failure(let error):
                debugPrint("Received an error: ", error)
            }
        }, receiveValue: {someValue in debugPrint("Received: ", someValue)})
    }
    
    private static func buildSession() -> URLSession {
        return URLSession(configuration: .default)
    }
}
