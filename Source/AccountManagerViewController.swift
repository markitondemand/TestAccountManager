//  Copyright © 2017 Markit. All rights reserved.
//

import UIKit

/// View controller that shows the current test accounts.
class AccountManagerViewController: UITableViewController {
    var testAccountManager: TestAccountManager!
        
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(AccountManagerViewController.dismissController))
    }
    

}

extension AccountManagerViewController {
    func dismissController() {
        //        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: SegueIdentifiers.Exit, sender: self)
    }
    
    private struct CellIdentifiers {
        static let AccountCell = "AccountCellIdentifier"
    }
    
    private struct SegueIdentifiers {
        static let Exit = "Exit"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = self.testAccountManager.account(indexPath: indexPath)!.account
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AccountCell)!
        cell.textLabel?.text = account.userName
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.testAccountManager.environments.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testAccountManager.countOfAccountsAt(section: section) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.testAccountManager.environment(index: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.testAccountManager.selectAccount(indexPath: indexPath)
        self.dismissController()
    }
}
