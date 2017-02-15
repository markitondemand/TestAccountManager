//  Copyright © 2017 Markit. All rights reserved.
//

import UIKit
import MD_Extensions

extension TestAccountManager {
    static let StoryboardName = "TestAccountStoryboard"
    /// Generates a simple UI to represent and interact with the TestAccountManager. This is not a UINavigationController and you may want to wrap this inside of your own UINavigationController before presentation
    ///
    /// - Returns: The viewcontroller to present in your UI.
    public func generateViewController() -> UIViewController {
        let podBundle = Bundle(for: type(of:self))
        let URL = podBundle.url(forResource: "MDTestAccountManager", withExtension: "bundle")!
        let resourceBundle = Bundle(url: URL)
        let controller = UIStoryboard(name: TestAccountManager.StoryboardName, bundle: resourceBundle).instantiateInitialViewController() as! AccountManagerViewController
        controller.testAccountManager = self
        return controller
    }
}

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
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AccountManagerViewController {
    private struct CellIdentifiers {
        static let AccountCell = "AccountCellIdentifier"
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
