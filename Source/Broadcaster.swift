//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation


/// This protocol defines the contract
public protocol AccountBroadcaster {
    func selected(account: Account, environment: String)
}



extension Notification.Name {
    static let AccountSelected = Notification.Name("AccountSelected")
}
class NotificationBroadcaster: AccountBroadcaster {
    
    func selected(account: Account, environment: String) {
        NotificationCenter.default.post(name: .AccountSelected, object: (account, environment))
    }
}

