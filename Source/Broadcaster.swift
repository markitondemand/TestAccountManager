//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation


/// This protocol defines the contract for clients to be alerted in the event a new account is selcted in the TestAccountManager
public protocol AccountBroadcaster {
    func selected(account: Account, environment: String)
}



extension Notification.Name {
    static let AccountSelected = Notification.Name("AccountSelected")
}
class NotificationBroadcaster: AccountBroadcaster {
    
    func selected(account: Account, environment: String) {
        NotificationCenter.default.post(name: .AccountSelected, object: self, userInfo:["Account": account, "Environment": environment])
    }
}

