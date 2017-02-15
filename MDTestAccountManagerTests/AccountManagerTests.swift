//  Copyright © 2017 Markit. All rights reserved.
//

import XCTest
@testable import MDTestAccountManager

class TestAccountManagerTests: XCTestCase {
    var accountManager: TestAccountManager!
    override func setUp() {
        accountManager = TestAccountManager()
    }
    func testAccountCreation() {
        
        let account = Account(userName: "name", password: "password")
        
        XCTAssertNotNil(account)
    }
    
    func testAccountManagerCreaton() {
        
//        let manager = TestAccountManager()
        
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
        let account1 = Account(userName: "abc", password: "password")
        let account2 = Account(userName: "def", password: "password")
        accountManager.register(account: account1, environment: "Test1")
        accountManager.register(account: account2, environment: "Test1")
        
        accountManager.deregister(account: account1, environment: "Test1")
        XCTAssertFalse(accountManager.accounts(environment: "Test1")!.contains(account1))
        
        accountManager.deregister(account: account2, environment: "Test1")
        XCTAssertNil(accountManager.accounts(environment: "Test1"))
    }
    
    func testDefaultEnvironment() {
        XCTAssertEqual(TestAccountManager.DefaultEnvironment ,"Test")
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
        XCTAssertTrue(notificationObserver.receivedNotification)
        let selectedAccount = notificationObserver.payload[AccountSelectedKeys.Account] as! Account
        let environment = notificationObserver.payload[AccountSelectedKeys.Environment] as! String
        XCTAssertEqual(selectedAccount, account)
        XCTAssertEqual(environment, "Test")
    }
    
    func testIndexPathAccessors() {
        let accountA = Account(userName: "TestUser", password: "password")
        let accountB = Account(userName: "ProdUser", password: "password")
        let accountC = Account(userName: "AProdUser", password: "password")
        accountManager.register(account: accountA, environment: "test")
        accountManager.register(account: accountB, environment: "prod")
        accountManager.register(account: accountC, environment: "prod")
        let mockBroadcaster = MockBroadcaster()
        accountManager.add(broadcaster: mockBroadcaster)
        
        XCTAssertEqual(accountManager.account(indexPath: IndexPath(row: 1, section: 0))?.account, accountB)
        XCTAssertEqual(accountManager.account(indexPath: IndexPath(row: 0, section: 1))?.account, accountA)
        
        XCTAssertNil(accountManager.account(indexPath: IndexPath(row: 99, section: 0)))
        XCTAssertNil(accountManager.account(indexPath: IndexPath(row: 0, section: 99)))
        
        XCTAssertEqual(accountManager.countOfAccountsAt(section: 0), 2)
        XCTAssertNil(accountManager.countOfAccountsAt(section: 2))
        
        accountManager.select(pair: ("prod", accountB))
        XCTAssertTrue(mockBroadcaster.didSelect(account: accountB))
        
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
    var payload: [AnyHashable:Any] = [:]
    
    func watchNotification(name: Notification.Name) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { notif in
            self.receivedNotification = true
            self.payload = notif.userInfo!
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
