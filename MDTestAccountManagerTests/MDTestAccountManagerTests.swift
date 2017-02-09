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
    
    func testAccountManagerCreaton() {
        
        
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
        XCTAssertEqual(prodAccounts.first?.userName, "prodUser")
    }
    
    func testDeregisterAccountForEnvironment() {
        let account = Account(userName: "abc", password: "password")
        accountManager.register(account: account, environment: "Test1")
        
        // May want this to throw, if no account is found for a given environment... not sure
        accountManager.deregister(account: account, environment: "Test1")
        XCTAssertNil(accountManager.accounts(environment: "Test1"))
    }
    
    func testDefaultEnvironment() {
        XCTAssertEqual(TestAccountManager.defaultEnvironment ,"Test")
    }
    
    func testGetEnvironments() {
        let environments = TestAccountManager().environments
        XCTAssertTrue(environments.isEmpty)
        
        accountManager.register(account: Account(userName:"abc", password:"123"), environment: "Env1")
        
        XCTAssertEqual(accountManager.environments, ["Env1"])
    }
    
    func testSelectAccountBroadcasts() {
        // Given
        let account = Account(userName: "TestUser", password: "password")
        accountManager.register(account: account)
        
        let mockBroadcaster1 = MockBroadcaster()
        let mockBroadcaster2 = MockBroadcaster()
        accountManager.add(broadcaster:mockBroadcaster1)
        accountManager.add(broadcaster:mockBroadcaster2)
        
        // When
        accountManager.select(account: account)
        
        // Then
        XCTAssertTrue(mockBroadcaster1.didSelect(account: account))
        XCTAssertTrue(mockBroadcaster2.didSelect(account: account))
    }
    
    func testSelectAccountNotRegisteredDoesNotBroadcast() {
        // Given
        let account = Account(userName: "TestUser", password: "password")
        
        let mockBroadcaster = MockBroadcaster()
        accountManager.add(broadcaster:mockBroadcaster)
        
        // When
        accountManager.select(account: account)
        
        // Then
        XCTAssertFalse(mockBroadcaster.didSelect(account: account))
    }

    func testNotificationBroadcaster() {
        // Given
        let account = Account(userName: "TestUser", password: "password")
        accountManager.register(account:account)
        accountManager.add(broadcaster: NotificationBroadcaster())
        let notificationObserver = NotificationObserver()
        notificationObserver.watchNotification(name: .AccountSelected)
        
        
        // When
        accountManager.select(account: account)
        
        // then
        XCTAssert(notificationObserver.receivedNotification)
    }
}


class MockBroadcaster: AccountBroadcaster {
    var selectedAccountList = Set<Account>()
    func didSelect(account: Account) -> Bool {
        return self.selectedAccountList.contains(account)
    }
    
    // Broadcaster impl
    func selected(account: Account, environment: String) {
        self.selectedAccountList.insert(account)
    }
}

class NotificationObserver {
    var receivedNotification = false
    
    func watchNotification(name: Notification.Name) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { _ in
            self.receivedNotification = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
