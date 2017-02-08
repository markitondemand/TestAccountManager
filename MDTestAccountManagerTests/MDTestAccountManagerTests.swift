//
//  MDTestAccountManagerTests.swift
//  MDTestAccountManagerTests
//
//  Created by Michael Leber on 2/8/17.
//  Copyright © 2017 Markit. All rights reserved.
//

import XCTest
@testable import MDTestAccountManager

class MDTestAccountManagerTests: XCTestCase {
    var accountManager: TestAccountManager!
    override func setUp() {
        accountManager = TestAccountManager()
    }
    func testAccountCreation() {
        
        let account = Account(userName: "name", password: "password")
        
        XCTAssertNotNil(account)
    }
    
    func testAccountEquality() {
        let account1 = Account(userName: "Some User", password: "A Long Password")
        let account2 = Account(userName: "Some User", password: "A Long Password")
        
        XCTAssertEqual(account1, account2)
    }
    
    func testRegisterAccount() {
        let account = Account(userName: "name", password: "password")
        accountManager.register(account: account)
        
        let accounts = accountManager.accounts()
        XCTAssertTrue(accounts?.count == 1)
    }
    
    func testRegisterAccountForEnvironment() {
        
        let accountAcc = Account(userName: "accUser", password: "password")
        let accountProd = Account(userName: "prodUser", password: "password")
        
        accountManager.register(account: accountAcc, environment: "Acc")
        accountManager.register(account: accountProd, environment: "Prod")
        
        let prodAccounts = accountManager.accounts(environment: "Prod")!
        XCTAssertEqual(prodAccounts[0].userName, "prodUser")
    }
    
    func testDeregisterAccountForEnvironment() {
        let account = Account(userName: "abc", password: "password")
        accountManager.register(account: account, environment: "Test1")
        
        // May want this to throw, if no account is found for a given environment... not sure
        accountManager.deregister(account: account, environment: "Test1")
        XCTAssertNil(accountManager.accounts(environment: "Test1"))
    }
    
    func testGetEnvironments() {
        let environments = TestAccountManager().environments
        XCTAssertTrue(environments.isEmpty)
        
        accountManager.register(account: Account(userName:"abc", password:"123"), environment: "Env1")
        
        XCTAssertEqual(accountManager.environments, ["Env1"])
    }
    
//    func testAaccessAccount() {
//        
//    }
    
    func testSelectAccount() {
//        XC
        // Test that setting the current account triggers a notification or some event, i.e. have an abstract protocol on the account manager that can act as a "broadcaster"
    }
}
