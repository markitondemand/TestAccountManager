//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation


// MARK: - Acessors for getting the Storyboard UI
extension UIStoryboard {
    public static let testAccountStoryboardName = "TestAccountStoryboard"
    
    /// Returns the storyboard that this
    public static var testAccountStoryboard: UIStoryboard {
        return UIStoryboard(name: UIStoryboard.testAccountStoryboardName, bundle: Bundle.testAccountManagerResourceBundle)
    }
}


// MARK: - Accessors for getting the resource bundle
extension Bundle {
    internal static let testAccountManagerResourceBundleName = "MDTestAccountManager"
    
    internal static var testAccountManagerResourceBundle: Bundle {
        return BundleAccessor().resourceBundleNamed(Bundle.testAccountManagerResourceBundleName)!
    }
    
    /// Needed to work around an issue with cocoapods where they dont let you set your own bundle identifier
    private class BundleAccessor {
        func resourceBundleNamed(_ name: String) -> Bundle? {
            let frameworkBundle = Bundle(for: type(of: self))
            
            guard let bundleUrl = frameworkBundle.url(forResource: name, withExtension: "bundle") else {
                return nil
            }
            return Bundle(url: bundleUrl)
        }
    }
}


// MARK: - Accessor for getting the initial view controller of the storyboard
extension TestAccountManager {
    
    /// Returns a view controller that represents a simple up for interacting with the TestAccountManager. This is not a UINavigationController and you may want to wrap this inside of your own UINavigationController before presentation
    ///
    /// - Returns: The viewcontroller to present in your UI.
    public func generateViewController() -> UIViewController {
        let controller = UIStoryboard.testAccountStoryboard.instantiateInitialViewController() as! AccountManagerViewController
        controller.testAccountManager = self
        return controller
    }
}


/// Implement this protocol method somewhere in your application where you presented this UI from to allow the account manager to unwind. This function will be called when the presented viewcontroller unwinds
public protocol Unwindable {
    func unwind(toExit segue:UIStoryboardSegue)
}
