//
//  JWTFactory.swift
//  DPCKit
//
//  Created by Nicholas Robison on 12/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import SwiftJWT

struct JWTFactory {

    private let clientToken: String
    private let baseURL: String
    private let signer: JWTSigner
    
    init(key: SecKey, clientToken: String, baseURL: String) {
        self.clientToken = clientToken
        self.baseURL = baseURL
        self.signer = JWTSigner(name: "RS384", signerAlgorithm: DPCSigner(privateKey: key))
    }
    
    func generate() -> String? {
        let claims = DPCClaims(clientToken: "test token", baseUrl: "http://localhost:3001/v1/")
        let header = Header(kid: "this is a key id")
        
        var jwt = JWT(header: header, claims: claims)
        return try? jwt.sign(using: self.signer)
    }
}
