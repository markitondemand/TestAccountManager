//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation
import MD_Extensions

/// The TestAccountManager handles managing test login accounts for different environments. It also includes support for broadcasting messages in the event an account is selected (i.e. in a menu system, when an account is selected this can than broadcast the selected account and environment so that you can fill in login details automatically)
public class TestAccountManager {
    public typealias EnvironmentAccount = (environment: String, account: Account)
    
    //TOOD: can refactor this to a single "set" of "EnvironmentAccount" tuple - however, we need to wrap the tuple in a struct as you cant hashable a tuple (but you can than hashable the struct)
    internal typealias AccountStore = [String:Set<Account>]
    internal var allAccounts: AccountStore = [:]
    
    // Default use the NotificationBroadcaster.
    internal var broadcasters: [AccountBroadcaster] = [NotificationBroadcaster()]
    
    /// The default environment. This is used if you do not supply an environment when registering accounts.
    public static let DefaultEnvironment = "Test"
    
    
    /// Basic Init method. This method takes a Dictionary of environments to a Set of Accounts
    ///
    /// - Parameter accounts: The incoming data structure to preload the manager with
    public init(accounts: [String: Set<Account>] = [:]) {
        allAccounts = accounts
    }
}


// MARK: - Account registration, deregistration and access
extension TestAccountManager {
    /// All of the active environments. This will return an empty array if no accounts are registered
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
        
        // due to copy nature of structs we need to reset the instance here.
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
        else {
            // due to copy nature of structs we need to reset the instance here.
            allAccounts[environment] = setOfAccounts
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
    
    
    /// Select an account. The account must be already registered for the given environment or nothing will be done. This will initiate a message to all active broadcasters of what account was selected. Call this from your UI if you allow the selection of an account from a table view.
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
    
    
    /// Takes a tuple of (String, Account) and attempts to select the account that matches. If no account is found with the given environment no operation occurs.
    ///
    /// - Parameter pair: The pair to select
    public func select(pair: EnvironmentAccount) {
        self.select(account: pair.account, environment:pair.environment)
    }
}

// MARK: - IndexPath support
extension TestAccountManager {
    
    /// Attempts to find an Environment Account pair based on an index path. This method will sort the environment as sections and then sort the accounts by user name for rows. This will return nil if no account is found.
    ///
    /// - Parameter indexPath: The indexpath to search
    /// - Returns: A matching account pair or nil
    public func account(indexPath: IndexPath) -> EnvironmentAccount? {
        guard let environment = self.mapSectionNumberToEnvironment(section: indexPath.section) else {
            return nil
        }
        
        guard let account = self.accounts(environment: environment)?.sorted(by: {
            return $0.userName < $1.userName
        })[safe: indexPath.row] else {
            return nil
        }
        
        return (environment, account)
    }
    
    /// Attempts to return the enviropnment from an integer index. This is done by sorting the environments in ascending order. If no environment is found (i,e, out of bounds), nil is returned
    ///
    /// - Parameter index: The index to check
    /// - Returns: A matching environment, or nil
    public func environment(index: Int) -> String? {
        return self.mapSectionNumberToEnvironment(section: index)
    }
    
    
    /// Returns a count of the accounts found for a given section mapped to an enviornment. The environments will be ordered in ascending order by name.
    ///
    /// - Parameter section: The section to check
    /// - Returns: The count of items. If the section is out of bounds nil is returned
    public func countOfAccountsAt(section: Int) -> Int? {
        guard let environment = self.mapSectionNumberToEnvironment(section: section) else {
            return nil
        }
        return self.accounts(environment: environment)?.count
    }
    
    /// Selects an account at a given indexPath. If no account is found than nothing is done.
    ///
    /// - Parameter indexPath: The indexpath to select
    public func selectAccount(indexPath: IndexPath) {
        guard let pair = self.account(indexPath: indexPath) else {
            return
        }
        
        self.select(pair: pair)
    }
    
    private func mapSectionNumberToEnvironment(section: Int) -> String? {
        let sortedEnvironments = self.environments.sorted(by: <)
        return sortedEnvironments[safe: section]
    }
}

