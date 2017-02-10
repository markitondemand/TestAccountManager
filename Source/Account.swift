//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation


/// Simple struct that wraps account data
public struct Account {
    let userName: String
    let password: String
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
