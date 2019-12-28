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
        self.aud = "\(baseUrl)token/auth"
        self.jti = UUID().uuidString
    }
}

class SMARTAuthHandler: RequestAdapter {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
    private let privateKey: SecKey
    private let clientToken: String
    private let baseURL: String
    
    init(privateKey: SecKey, clientToken: String, baseURL: String) {
        self.privateKey = privateKey
        self.clientToken = clientToken
        self.baseURL = baseURL
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        return
    }
    
    private func requestToken(completion: @escaping RefreshCompletion) -> Void {
        // Nothing yet
    }
}
