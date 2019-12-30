//
//  DPCKitTests.swift
//  DPCKitTests
//
//  Created by Nicholas Robison on 12/15/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import XCTest
import SwiftJWT
import Alamofire
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
    
    // This test can only be run locally, not for CI.
    //    func testSMARTAuth() {
    //        let privKey = getKey()!
    //        let keyID = "3cc80766-5a9f-408d-b00f-1d5aeb345e58"
    //
    //        let interceptor = SMARTAuthHandler(privateKey: privKey, keyID: keyID, clientToken: "W3sidiI6MiwibCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMiIsImkiOiI1ZGZjYzVkOS03MWY4LTRhNjMtOTdmMi0zZjU4NGY3NTc0NGYiLCJjIjpbeyJpNjQiOiJaSEJqWDIxaFkyRnliMjl1WDNabGNuTnBiMjRnUFNBeSJ9LHsiaTY0IjoiWlhod2FYSmxjeUE5SURJd01qQXRNVEl0TXpCVU1ETTZNek02TkRndU5ERTVNVGN6V2cifSx7Imk2NCI6ImIzSm5ZVzVwZW1GMGFXOXVYMmxrSUQwZ05EWmhZemRoWkRZdE56UTROeTAwWkdRd0xXSmhZVEF0Tm1VeVl6aGpZV1UzTm1FdyJ9LHsibCI6ImxvY2FsIiwiaTY0IjoiQW0wa1dzOXRKRnJQLUR1bW1Pd0FSbjMxcDZRTERsNEl2RUcxQlRQakVUbjlCeTBnZnQ2ZzVtcDlXNURjM3ZJTVVqSk5WbkN4a0JOMjFsMkFZa1VHOGdtZHM0dnVTaFdBU0lrMTU3X1BxdzA5cXliS2JyTU45UkNYOWhfTWlYY05aWlRoS1lEd3d5VENqZVl1a3FpdzQwdnlMb3M0Tk9wYldBcEJJYmpoZUtySmxmQ3RqQ2FGVE1aU3JBOVJPNDJuY2NqZ3g0N3RqSklnVjRPWF9BIiwidjY0IjoiU0pwRjlDbjNVTGRCOE9pRmt6MFNHaDlaYzFsTFdzMTBrSTB2LTZtOHM4bVhBaTZ0bncxNFdYSVFLTjZoQ012WFd5QjMzUGpfRm5PV05sem1USzVMakNGbWlGcEQxUU9kIn1dLCJzNjQiOiJ1Rl96TmZmNURRdENmVlBUUlUtellyRXJkbjkyNXlkY2w3dG5Jc1ZtcVowIn1d", baseURL: "http://localhost:3002/v1/")
    //
    //
    //        let session = Session(configuration: URLSessionConfiguration.default, interceptor: interceptor as RequestInterceptor)
    //
    //        let expectation = XCTestExpectation(description: "Should get org")
    //        session.request ("http://localhost:3002/v1/Organization/46ac7ad6-7487-4dd0-baa0-6e2c8cae76a0")
    //            .validate(statusCode: 200..<300)
    //            .validate(contentType: ["application/fhir+json"])
    //            .response{ response in
    //                debugPrint(response)
    //                expectation.fulfill()
    //        }
    //
    //        wait(for: [expectation], timeout: 70.0)
    //    }
    
    func testSignAndVerify() {
        let key = try! generateKeyPair()
        
        let factory = JWTFactory(key: key, keyID: "not real", clientToken: "test token", baseURL: "http://test.local")
        
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
    
    private func generateKeyPair() throws -> SecKey {
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
    
    private func getKey() -> SecKey? {
        let keyTag = "com.nickrobison.DPCExplorer.keys.PrimaryKey"
        let tag = keyTag.data(using: .utf8)!
        
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
    
}
