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
        let res = try! manager.generateKeyPair()
        
        let pem = try? manager.convertToPEM(key: res.1)
        XCTAssertNotNil(pem, "Should have PEM")
        
        // Try to convert it back to a public key, and make sure it works correctly
        let _ = try! CryptorRSA.createPublicKey(withPEM: pem!)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
