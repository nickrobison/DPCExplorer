//
//  SMARTAuthHandler.swift
//  DPCKit
//
//  Created by Nicholas Robison on 12/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import Alamofire
import SwiftJWT
import CryptorRSA

struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let scope: String? // Until the patch lands in DPC
}

struct DPCClaims: Claims {
    let iss: String
    let sub: String
    let exp: Int
    let aud: String
    let jti: String
    
    init(clientToken: String, baseUrl: String) {
        self.iss = clientToken
        self.sub = clientToken
        self.exp = Int(Date().timeIntervalSince1970 + (5.0 * 60.0))
        self.aud = "\(baseUrl)Token/auth"
        self.jti = UUID().uuidString
    }
}

class SMARTAuthHandler: RequestInterceptor {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    private typealias RetryResultCompletion = (RetryResult) -> Void
    
    private let privateKey: SecKey
    private let clientToken: String
    private let keyID: String
    private let baseURL: String
    private let factory: JWTFactory
    
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [RetryResultCompletion] = []
    // We need init logic here, we can't always fail the first request
    private var accessToken = ""
    
    init(privateKey: SecKey, keyID: String, clientToken: String, baseURL: String) {
        self.privateKey = privateKey
        self.keyID = keyID
        self.clientToken = clientToken
        self.baseURL = baseURL
        // We need some init logic here. We can't always fail on the first request
        self.factory = JWTFactory(key: privateKey, keyID: keyID, clientToken: clientToken, baseURL: baseURL)
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(self.baseURL) {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + self.accessToken, forHTTPHeaderField: "Authorization")
            return completion(.success(urlRequest))
        }

        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock(); defer {
            lock.unlock()
        }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            self.requestsToRetry.append(completion)
            
            if !isRefreshing {
                requestToken(session: session) {
                    [weak self] succeeded, accessToken in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let accessToken = accessToken {
                        strongSelf.accessToken = accessToken
                    }
                    
                    strongSelf.requestsToRetry.forEach {
                        $0(.retry)
                    }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
    
    private func requestToken(session: Session, completion: @escaping RefreshCompletion) -> Void {
        guard !isRefreshing else {
            return
        }
        
        self.isRefreshing = true
        
        let urlString = "\(self.baseURL)Token/auth"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        guard let jwt = self.factory.generate() else {
            return
        }
        
        let parameters: [String: String] = [
            "scope": "system/*.*",
            "grant_type": "client_credentials",
            "client_assertion_type": "urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
            "client_assertion": jwt
        ]
        
        session.request(urlString, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
            .responseDecodable(of: TokenResponse.self) { [weak self] response in
                guard let strongSelf = self else { return }
                debugPrint(response)
                if let tokenResp = response.value {
                    completion(true, tokenResp.access_token)
                } else {
                    completion(false, nil)
                }
                strongSelf.isRefreshing = false
        }
    }
}
