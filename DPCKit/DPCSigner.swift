//
//  DPCSigner.swift
//  DPCKit
//
//  Created by Nicholas Robison on 12/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation
import SwiftJWT

struct DPCSigner: SignerAlgorithm {

    private let privateKey: SecKey

    init(privateKey: SecKey) {
        self.privateKey = privateKey
    }


    func sign(header: String, claims: String) throws -> String {
        let unsignedJWT = header + "." + claims
        guard let unsignedData = unsignedJWT.data(using: .utf8) else {
            throw JWTError.invalidJWTString
        }

        let signature = try sign(unsignedData)
        let signatureString = JWTEncoder.base64urlEncodedString(data: signature)
        return header + "." + claims + "." + signatureString
    }

    private func sign(_ data: Data) throws -> Data {
        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(self.privateKey, Data.Algorithm.sha384.algorithmForSignature, data as CFData, &error) else {
            throw error!.takeRetainedValue() as Error
        }

        return signature as Data
    }

}
