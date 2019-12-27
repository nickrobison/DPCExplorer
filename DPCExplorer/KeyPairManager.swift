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
    
    func generateKeyPair() throws {
        let tag = KeyPairManager.keyTag.data(using: .utf8)!
        
        let attributes: [String: Any] =
        [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 4096,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: tag,
                kSecAttrCanEncrypt as String: true,
                kSecAttrCanDecrypt as String: true]
        ]
        
        var error: Unmanaged<CFError>?
        guard SecKeyCreateRandomKey(attributes as CFDictionary, &error) != nil else {
            throw error!.takeRetainedValue() as Error
        }
    }
    
    func getPrivateKey() -> SecKey? {
        let tag = KeyPairManager.keyTag.data(using: .utf8)!
        
        let getQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        
        return (item as! SecKey)
    }
    
    func getPublicKey() -> SecKey? {
        guard let priv = getPrivateKey() else {
            return nil
        }
        
        return SecKeyCopyPublicKey(priv)
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
