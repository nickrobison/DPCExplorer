//
//  BlueButtonKitTests.swift
//  BlueButtonKitTests
//
//  Created by Nicholas Robison on 12/18/19.
//  Copyright © 2019 Nicholas Robison. All rights reserved.
//

import XCTest
@testable import BlueButtonKit

class BlueButtonKitTests: XCTestCase {
    
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
    
    // MARK: EOB extraction tests
    
    func testDateExtraction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let date = testEOB.item![0].getDate()
        XCTAssertNotNil(date, "Should have date from EOB item")
        
        XCTAssertEqual("2015-04-01", formatter.string(from: date!), "Dates should be equal")
    }
    
    func testPrimaryPhysicianExtraction() {
        let provider = testEOB.primaryPhysician
        XCTAssertNotNil(provider, "Should have primary provider")
        XCTAssertEqual("999999999999", provider!.identifier!.value!.string, "Should have correct NPI")
    }
    
    // MARK: EOB item extraction tests
    
    func testServiceCodeExtraction() {
        let item = testEOB.item![0]
        XCTAssertEqual("99203", item.serviceCode, "Should have correct service code")
    }
    
}
