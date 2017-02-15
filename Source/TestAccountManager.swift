//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation

/// The TestAccountManager handles managing test login accounts for different environments. It also includes support for broadcasting messages in the event an account is selected (i.e. in a menu system, when an account is selected this can than broadcast the selected account and environment so that you can fill in login details automatically)
public class TestAccountManager {
    internal typealias AccountStore = [String:Set<Account>]
    internal var allAccounts: AccountStore = [:]
    // Default use the NotificationBroadcaster.
    // TOOD: unit tests/ possibly better DI for this (maybe someone doesnt want any broadcaster? or just there own?)
    internal var broadcasters: [AccountBroadcaster] = [NotificationBroadcaster()]
    
    /// The default environment. This is used if you do not supply an environment when registering accounts
    public static let DefaultEnvironment = "Test"
    
    public init(accounts: [String: Set<Account>] = [:]) {
        allAccounts = accounts
    }
}


// MARK: - Account registration, deregistration and access
extension TestAccountManager {
    /// All of the active environments. This will return an empty array if no accoutn is registered
    public var environments: [String] {
        get { return Array(self.allAccounts.keys) }
    }
    
    /// Registers an account to a given environment
    ///
    /// - Parameters:
    ///   - account: The account to register
    ///   - environment: The environment to register the account. by default "test" will be used
    public func register(account: Account, environment: String = DefaultEnvironment) {
        guard var envAccounts = allAccounts[environment] else {
            allAccounts[environment] = [account]
            return
        }
        envAccounts.insert(account)
        allAccounts[environment] = envAccounts
    }
    
    
    /// Attempts to deregister an account for a given environment. If no account is found nothing is done.
    ///
    /// - Parameters:
    ///   - account: The account to deregister
    ///   - environment: The environment the account is for
    public func deregister(account: Account, environment: String = DefaultEnvironment) {
        guard var setOfAccounts = allAccounts[environment] else {
            return
        }
        
        setOfAccounts.remove(account)
        
        // clean up and remove the empty array if we are out of elements
        if(setOfAccounts.isEmpty) {
            allAccounts[environment] = nil
        }
    }
    
    
    /// Optionally returns an array of accounts for a given environment. If no environemnt or no accounts in an environment are found, nil is returned.
    ///
    /// - Parameter environment: The environment to check
    /// - Returns: A Set of accounts for an environment, or nil
    public func accounts(environment: String = DefaultEnvironment) -> Set<Account>? {
        guard let envAccounts = self.allAccounts[environment] else {
            return nil
        }
        return envAccounts
    }
}

// MARK: - Account selection and broadcasting
extension TestAccountManager {
    
    /// Adds a new broadcaster that will be alerted when an account is selected. Please see AccountBroadcaster for details
    ///
    /// - Parameter broadcaster: The broadcaster to be added
    public func add(broadcaster: AccountBroadcaster) {
        self.broadcasters.append(broadcaster)
    }
    
    
    /// Select an account. The account must be already registered for the given environment or nothing will be done. This will initiate a message to all broadcaster of what account was selected. Call this from your UI if you allow the selection of an account from a table view.
    ///
    /// - Parameters:
    ///   - account: The account was selected.
    ///   - environment: The environment the account belongs to.
    public func select(account: Account, environment: String = DefaultEnvironment) {
        guard let accounts = self.accounts(environment: environment) else {
            return
        }
        guard accounts.contains(account) else {
            return
        }
        for broadcaster in self.broadcasters {
            broadcaster.selected(account: account, environment: environment)
        }
    }
}

// MARK: - IndexPath support
extension TestAccountManager {
    
    /// This method will accept an IndexPath and attempt to return an account for it. This method will sort the environment as sections and then sort the accounts by user name for rows.  This will return nil if no account is found.
    ///
    /// - Parameter indexPath: The IndexPath to search
    /// - Returns: A matching account or nil
    public func account(indexPath: IndexPath) -> Account? {
        guard let environment = self.mapSectionNumberToEnvironment(section: indexPath.section) else {
            return nil
        }
        
        guard let accounts = self.accounts(environment: environment) else {
            return nil
        }
        
        return accounts.sorted(by: {
            return $0.userName < $1.userName
        })[safe: indexPath.row]
    }
    
    /// Attempts to return the enviropnment from an integer index. This is done by sorting the environments in ascending order. If no environment is found (i,e, out of bounds), nil is returned
    ///
    /// - Parameter index: The index to check
    /// - Returns: A matching environment, or nil
    public func environment(index: Int) -> String? {
        return self.mapSectionNumberToEnvironment(section: index)
    }
    
    
    /// Selects an account at a given indexPath. If no account is found than nothing is done.
    ///
    /// - Parameter indexPath: The indexpath to select
    public func selectAccount(indexPath: IndexPath) {
        
//        self.select(account: <#T##Account#>)
    }
    
    private func mapSectionNumberToEnvironment(section: Int) -> String? {
        let sortedEnvironments = self.environments.sorted(by: >)
        return sortedEnvironments[safe: section]
    }
}

