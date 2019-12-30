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
    private let keyID: String
    private let baseURL: String
    private let signer: JWTSigner
    
    init(key: SecKey, keyID: String, clientToken: String, baseURL: String) {
        self.clientToken = clientToken
        self.keyID = keyID
        self.baseURL = baseURL
        self.signer = JWTSigner(name: "RS384", signerAlgorithm: DPCSigner(privateKey: key))
    }
    
    func generate() -> String? {
        let claims = DPCClaims(clientToken: self.clientToken, baseUrl: self.baseURL)
        let header = Header(kid: self.keyID)
        
        var jwt = JWT(header: header, claims: claims)
        return try? jwt.sign(using: self.signer)
    }
}
