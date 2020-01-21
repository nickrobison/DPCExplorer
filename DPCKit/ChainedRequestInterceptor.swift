//
//  ChainedRequestAdaptor.swift
//  DPCKit
//
//  Created by Nicholas Robison on 1/20/20.
//  Copyright © 2020 Nicholas Robison. All rights reserved.
//

import Foundation
import Alamofire

class ChainedRequestInterceptor: RequestInterceptor {
    let interceptors: [RequestInterceptor]
    
    init(interceptors: [RequestInterceptor]) {
        self.interceptors = interceptors
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        self.interceptors.forEach {interceptor in
            interceptor.adapt(urlRequest, for: session, completion: completion)
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        self.interceptors.forEach { interceptor in
            interceptor.retry(request, for: session, dueTo: error, completion: completion)
        }
    }
}
