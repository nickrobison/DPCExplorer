//
//  DPCKitTests.swift
//  DPCKitTests
//
//  Created by Nicholas Robison on 12/15/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import XCTest
import SwiftJWT
@testable import DPCKit

class DPCKitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSignAndVerify() {
        let key = try! generateKeyPair()
        
        let factory = JWTFactory(key: key, clientToken: "test token", baseURL: "http://test.local")
        
        let jwt = factory.generate()!
        
        let pubKey = SecKeyCopyPublicKey(key)!
        let export = CryptoExportImportManager()
        
        var error: Unmanaged<CFError>?
        let external = SecKeyCopyExternalRepresentation(pubKey, &error)!
        let pemKey = export.exportPublicKeyToPEM(external as Data, keyType: kSecAttrKeyTypeRSA as String, keySize: 4096)!.data(using: .utf8)
        
        
        
        let verifier = JWTVerifier.rs384(publicKey: pemKey!)
        let verified = JWT<DPCClaims>.verify(jwt, using: verifier)
        XCTAssert(verified, "Should be verified")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: Helper functions
    
    func generateKeyPair() throws -> SecKey {
        let tag = "This.is.a.test.key".data(using: .utf8)!
        
        let attributes: [String: Any] =
        [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 4096,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: false,
                kSecAttrApplicationTag as String: tag,
                kSecAttrCanEncrypt as String: true,
                kSecAttrCanDecrypt as String: true]
        ]
        
        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        return key
    }

}
