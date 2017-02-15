//  Copyright © 2017 Markit. All rights reserved.
//

import UIKit


extension TestAccountManager {
    
    /// Generates a simple UI to represent and interact with the TestAccountManager
    ///
    /// - Returns: The viewcontroller to present in your UI
    public func generateViewController() -> AccountManagerViewController {
        return AccountManagerViewController(testAccountManager: self)
    }
}

public class AccountManagerViewController: UITableViewController {
    let testAccountManager: TestAccountManager
    
    public init(testAccountManager: TestAccountManager) {
        self.testAccountManager = testAccountManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    public class AccountTableViewCell: UITableViewCell {
//    }
}

extension AccountManagerViewController {
    private struct CellIdentifiers {
        static let AccountCell = "AccountCellIdentifier"
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AccountCell)!
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let environment = self.testAccountManager.environment(index: section) else {
            return 0
        }
        guard let accounts = self.testAccountManager.accounts(environment: environment) else {
            return 0
        }
        
        return accounts.count
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

}


// TOOD: port to MD-Extensions
extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
