//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation


/// This protocol defines the contract for clients to be alerted in the event a new account is selcted in the TestAccountManager
public protocol AccountBroadcaster {
    func selected(account: Account, environment: String)
}


public extension Notification.Name {
    /// This notification is if the NotificationBroadcaster is set on the account manager and an account is selected. The "Account" and "Environment" are passed in the UserInfo
    static let AccountSelected = Notification.Name("AccountSelected")
}

/// Keys that correspond to the values in the UserInfo dictionary for the AccountSelected notification
///
/// - Account: The Account key. The object will be of type Account
/// - Environment: The Environment key. This will be the naem of the Environment as a String
public enum AccountSelectedKeys: String {
    case Account
    case Environment
}

/// Private internal class that will broadcast Notifications
class NotificationBroadcaster: AccountBroadcaster {
    func selected(account: Account, environment: String) {
        NotificationCenter.default.post(name: .AccountSelected, object: self, userInfo:[AccountSelectedKeys.Account: account, AccountSelectedKeys.Environment: environment])
    }
}
