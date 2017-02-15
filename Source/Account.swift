//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation


/// Simple struct that wraps account data
public struct Account {
    
    /// Represents the user name
    public let userName: String
    
    /// Represents the password
    public let password: String
    
    
    /// Standard init method
    ///
    /// - Parameters:
    ///   - userName: The user name to use
    ///   - password: The password to use
    public init(userName: String, password: String) {
        self.userName = userName
        self.password = password
    }
}


// MARK: - Account Equatable
extension Account: Equatable {
    public static func ==(lhs: Account, rhs: Account) -> Bool {
        return (lhs.userName == rhs.userName) && (lhs.password == rhs.password)
    }
}


// MARK: - Account Hashable
extension Account: Hashable {
    public var hashValue: Int {
        return "\(self.userName)\(self.password)".hashValue
    }
}
