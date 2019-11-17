//
//  ExportClient.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 11/17/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

class ExportClient {
    
    private let defaultURLSession: URLSession
    private let baseURL: String
    
    var dataTask: URLSessionDataTask?
    
    init(with: String) {
        self.defaultURLSession = ExportClient.buildSession()
        self.baseURL = with
    }
    
    public func exportData(groupID: UUID) {
        dataTask?.cancel()
        
        guard let exportString = "\(self.baseURL)Group/\(groupID.uuidString.lowercased())/$export".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
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
        
        self.dataTask = self.defaultURLSession.dataTask(with: request){ [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                debugPrint("Error!", error)
            } else if
                let response = response as? HTTPURLResponse,
                response.statusCode == 202 {
                debugPrint("Export started")
            } else {
                let err = String(decoding: data!, as: UTF8.self)
                
                debugPrint("Error starting", err)
            }
    }
        self.dataTask?.resume()
    }
    
    private static func buildSession() -> URLSession {
        return URLSession(configuration: .default)
    }
}
