//
//  KeyPairManager.swift
//  DPCExplorer
//
//  Created by Nicholas Robison on 12/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import Foundation

struct KeyPairManager {
    
    public static let keyTag = "com.nickrobison.DPCExplorer.keys.PrimaryKey"
    
    func generateKeyPair() throws -> (String, SecKey) {
        let tag = KeyPairManager.keyTag.data(using: .utf8)!
        
        let attributes: [String: Any] =
        [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 4096,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: tag]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        let publicKey = SecKeyCopyPublicKey(privateKey)!
        
        return ("Test", publicKey)
    }
    
    func convertToPEM(key: SecKey) throws -> String? {
        let exportManager = CryptoExportImportManager()
        var error: Unmanaged<CFError>?
        guard let external = SecKeyCopyExternalRepresentation(key, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        return exportManager.exportPublicKeyToPEM(external as Data, keyType: kSecAttrKeyTypeRSA as String, keySize: 4096)
    }
    
}
