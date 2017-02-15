//
//  ViewController.swift
//  Example
//
//  Created by Michael Leber on 2/15/17.
//  Copyright © 2017 Markit. All rights reserved.
//

import UIKit

import MDTestAccountManager

class ViewController: UIViewController {
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var environmentLabel: UILabel!
    var accountManager: TestAccountManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let csvStream = InputStream(url: Bundle.main.url(forResource: "Accounts", withExtension: "csv")!)!
        accountManager = TestAccountManager(stream: csvStream)
        
        NotificationCenter.default.addObserver(forName: .AccountSelected, object: nil, queue: nil) { (notification) in
            let account = notification.userInfo?[AccountSelectedKeys.Account] as! Account
            let environment = notification.userInfo?[AccountSelectedKeys.Environment] as! String
            self.userNameField.text = account.userName
            self.passwordField.text = account.password
            self.environmentLabel.text = environment
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapShowMenuButton(sender: Any?) {
        
        let navController = UINavigationController(rootViewController: accountManager.generateViewController())
        self.present(navController, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

