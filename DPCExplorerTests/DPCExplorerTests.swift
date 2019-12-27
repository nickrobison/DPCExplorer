//
//  DPCExplorerTests.swift
//  DPCExplorerTests
//
//  Created by Nicholas Robison on 10/27/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import XCTest
import CryptorRSA
@testable import DPCExplorer

class DPCExplorerTests: XCTestCase {
    
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
    
    func testKeyGeneration() {
        let manager = KeyPairManager()
        let _ = try! manager.generateKeyPair()
        
        let privKey = manager.getPrivateKey()!
        let pubKey = SecKeyCopyPublicKey(privKey)!
        
        guard SecKeyIsAlgorithmSupported(pubKey, .encrypt, Data.Algorithm.sha1.alogrithmForEncryption) else {
            return XCTFail("Cannot encrypt")
        }
        
        let pem = try? manager.convertToPEM(key: pubKey)
        XCTAssertNotNil(pem, "Should have PEM")
        
        // Try to convert it back to a public key, and make sure it works correctly
        let key = try! CryptorRSA.createPublicKey(withPEM: pem!)
        XCTAssertEqual(CryptorRSA.RSAKey.KeyType.publicType, key.type, "Should be a public key")
        
        // Try to encrypt/decrypt
        let plainText = "Test data"
        let plain = try! CryptorRSA.createPlaintext(with: plainText, using: String.Encoding.utf8)
        let encrypted = try! plain.encrypted(with: key, algorithm: .sha1)
        
        guard SecKeyIsAlgorithmSupported(privKey, .decrypt, Data.Algorithm.sha1.alogrithmForEncryption) else {
            return XCTFail("Algorithm not supported")
        }
        
        var error: Unmanaged<CFError>? = nil
        let clearText = SecKeyCreateDecryptedData(privKey, .rsaEncryptionOAEPSHA1AESGCM, encrypted!.data as CFData, &error)! as Data
        if error != nil {
            guard let err = error?.takeRetainedValue() else {
                return XCTFail("Not even an error")
            }
            return XCTFail("Decryption failed: \(err.humanized)")
        }
        XCTAssertEqual(String.init(data: clearText, encoding: .utf8), plainText)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
