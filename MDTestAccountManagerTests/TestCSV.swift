//
//  TestCSV.swift
//  MDTestAccountManager
//
//  Created by Michael Leber on 2/9/17.
//  Copyright © 2017 Markit. All rights reserved.
//

import XCTest

@testable import MDTestAccountManager

class TestCSV: XCTestCase {
    func testCreateAccountManagerWithSimpleCSV() {
        let simpleCSV = "UserName|Password|Environment\nTest1|pass123|Acc"
        let expected = Set([Account(userName: "Test1", password: "pass123")])
        
        let accountManager = TestAccountManager(CSVData:simpleCSV)!
        
        XCTAssertEqual(accountManager.accounts(environment: "Acc"), expected)
    }
    
    func testCreateAccountManagerWithCSVFile() {
        let streamOfFile = InputStream(url: Bundle(for: type(of: self)).url(forResource: "accounts", withExtension: ".csv")!)!
        let accountManager = TestAccountManager(stream: streamOfFile)!
        
        let expectedAcc = Set([Account(userName: "Test1", password: "pass123"), Account(userName: "Test2", password: "pass123")])
        let expectedProd = Set([Account(userName: "Prod1", password: "pass123"), Account(userName: "Prod2", password: "pass123")])
        
        // Then
        XCTAssertEqual(accountManager.accounts(environment: "Acc"), expectedAcc)
        XCTAssertEqual(accountManager.accounts(environment: "Prod"), expectedProd)
    }
}
