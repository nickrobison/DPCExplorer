//
//  ExportRetryHander.swift
//  DPCKit
//
//  Created by Nicholas Robison on 1/20/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import Foundation
import Alamofire

class ExportRetryHander: RequestInterceptor {
    
    private let delay: TimeInterval
    
    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        // If we get a 202, retry it, otherwise, fail
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 202 {
            debugPrint("Retrying 202")
            completion(.retryWithDelay(self.delay))
        } else {
            completion(.doNotRetry)
        }
    }
}
