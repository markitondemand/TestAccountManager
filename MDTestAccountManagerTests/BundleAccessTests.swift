//  Copyright © 2017 Markit. All rights reserved.
//

import XCTest
@testable import MDTestAccountManager

class BundleAccessTests: XCTestCase {

    func testStoryboardNameIsCorrect() {
        XCTAssertEqual(UIStoryboard.testAccountStoryboardName, "TestAccountStoryboard")
    }
    
    func testStoryboardCreation() {
        XCTAssertNotNil(UIStoryboard.testAccountStoryboard)
    }
    
    func testGenerateViewController() {
        let tm = TestAccountManager()
        XCTAssertNotNil(tm.generateViewController())
    }
    
    func testResourceBundleAccess() {
        XCTAssertNotNil(Bundle.testAccountManagerResourceBundle)
    }

    
}
