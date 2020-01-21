//
//  ExportWatcher.swift
//  DPCKit
//
//  Created by Nicholas Robison on 1/20/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import Foundation
import Alamofire

// Start an export Job and monitor for its completion
class ExportWatcher: Operation {
    
    typealias ExportCompletedHandler = ([JobOutputModel]) -> Void
    
    private let session: Session
    private let groupID: String
    private let retryHandler: ExportRetryHander
    private let smartHandler: SMARTAuthHandler
    private var request: DataRequest?
    private var handler: ExportCompletedHandler
    
    init(groupID: String, interceptor: SMARTAuthHandler, handler: @escaping ExportCompletedHandler) {
        self.groupID = groupID
        
        // Create a new http client with all the retriers, plus some
        self.retryHandler = ExportRetryHander(delay: TimeInterval(5))
        self.smartHandler = interceptor
        self.session = Session(configuration: URLSessionConfiguration.default)
        self.handler = handler
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        // Start the export job and monitor it
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 3002
        components.path = "/v1/Group/\(groupID)/$export"
        
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
        
        self.request = self.session.request(request, interceptor: self.smartHandler as RequestInterceptor)
            .validate(statusCode: 202...202)
            .validate(contentType: ["application/fhir+json"])
            .response { [weak self] response in
                guard let strongSelf = self else {
                    return
                }
                guard let response = response.response else {
                    // Signal out the error here
                    fatalError("Did not export correctly")
                }
                
                guard let location = response.headers["Content-Location"],
                    let jobURL = URL(string: location) else {
                        fatalError("Could not convert content location to URL")
                }
                debugPrint("Export started at: ", jobURL)
                strongSelf.monitorExport(jobURL: jobURL)
        }
    }
    
    private func monitorExport(jobURL: URL) {
        // Now, monitor it, retrying all the things
        self.request = self.session.request(jobURL, interceptor: ChainedRequestInterceptor(interceptors: [self.smartHandler, self.retryHandler]))
            .validate(statusCode: 200...200)
            .validate(contentType: ["application/fhir+json"])
            .responseDecodable(of: JobCompletionModel.self) {[weak self] response in
                guard let strongSelf = self else {
                    return
                }
                switch response.result {
                case .success:
                    guard let value = response.value else {
                        return
                    }
                    debugPrint("Export completed")
                    strongSelf.handler(value.output)
                case let .failure(error):
                    print(error)
                }
        }
    }
}
