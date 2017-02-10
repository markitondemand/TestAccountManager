//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation


/// This protocol defines the contract for clients to be alerted in the event a new account is selcted in the TestAccountManager
public protocol AccountBroadcaster {
    func selected(account: Account, environment: String)
}

//TOOD: type UserInfo to either our own tuple / struct, or define the keys the dictionary requires
public extension Notification.Name {
    /// This notification is if the NotificationBroadcaster is set on the account manager and an account is selected. The "Account" and "Environment" are passed in the UserInfo
    static let AccountSelected = Notification.Name("AccountSelected")
}


/// Private internal class that will broadcast Notifications
class NotificationBroadcaster: AccountBroadcaster {
    func selected(account: Account, environment: String) {
        NotificationCenter.default.post(name: .AccountSelected, object: self, userInfo:["Account": account, "Environment": environment])
    }
}

