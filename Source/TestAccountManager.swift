//
//  TestAccountManager.swift
//  MDTestAccountManager
//
//  Created by Michael Leber on 2/8/17.
//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation



public struct Account {
    let userName: String
    let password: String
}

extension Account: Equatable {
    public static func ==(lhs: Account, rhs: Account) -> Bool {
        return (lhs.userName == rhs.userName) && (lhs.password == rhs.password)
    }
}

extension Account: Hashable {
    public var hashValue: Int {
        return "\(self.userName)\(self.password)".hashValue
    }
}

public class TestAccountManager {
    private typealias AccountStore = [String:Set<Account>]
    
    private var allAccounts: AccountStore = [:]
    private static let defaultEnvironment = "test"
    
    public var environments: [String] {
        get { return Array(self.allAccounts.keys) }
    }
    
    /// Registers an account to a given environment
    ///
    /// - Parameters:
    ///   - account: The account to register
    ///   - environment: The environment to register the account. by default "test" will be used
    func register(account: Account, environment: String = defaultEnvironment) {
        guard var envAccounts = allAccounts[environment] else {
            allAccounts[environment] = [account]
            return
        }
        envAccounts.insert(account)
    }
    
    func deregister(account: Account, environment: String = defaultEnvironment) {
        guard var setOfAccounts = allAccounts[environment] else {
            return
        }
        
        setOfAccounts.remove(account)
        
        // clean up and remove the empty array if we are out of elements
        if(setOfAccounts.isEmpty) {
            allAccounts[environment] = nil
        }
    }
    
    func accounts(environment: String = defaultEnvironment) -> [Account]? {
        guard let envAccounts = self.allAccounts[environment] else {
            return nil
        }
        return Array(envAccounts)
    }
}

