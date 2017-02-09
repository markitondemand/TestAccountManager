//  Copyright © 2017 Markit. All rights reserved.
//

import Foundation
import CSV

extension TestAccountManager {
    struct Token {
        static let UserName = "UserName"
        static let Password = "Password"
        static let Environment = "Environment"
        static let Delimiter: UnicodeScalar = "|"
    }
    
    /// This initializaer expects a string of CSV Data in the following form
    /// Header - "Environment","UserName","Password"\n
    /// All other lines - "value1","value2","value3"\n
    convenience init?(CSVData: String) {
        var parsedCSV: CSV
        do {
             parsedCSV = try CSV(string: CSVData, hasHeaderRow: true, trimFields: false, delimiter: Token.Delimiter)
        } catch let error {
            print("Error loading the CSV data - CSVError:\(error)")
            return nil
        }
        
        self.init(parsedCSV: parsedCSV)
    }
    
    /// This initializaer expects an InputStream of a CSV File with the following form
    /// ```
    /// "Environment","UserName","Password"\n
    /// "value1","value2","value3"\n
    /// ```
    /// Nil will be returned and an error logged to the console in the event
    convenience init?(stream: InputStream) {
        var parsedCSV: CSV
        do {
            parsedCSV = try CSV(stream: stream, hasHeaderRow: true, trimFields: false, delimiter: Token.Delimiter)
        } catch let error {
            print("Error loadingthe CSV data - CSVError:\(error)")
            return nil
        }
        
        self.init(parsedCSV: parsedCSV)
    }
    
    // Helper initializer that coaleases the above initializers.
    private convenience init?(parsedCSV: CSV) {
        var structure: [String: Set<Account>] = [:]
        var parsedCSV = parsedCSV
        
        while let _ = parsedCSV.next() {
            guard let environment = parsedCSV[Token.Environment],
                let userName = parsedCSV[Token.UserName],
                let password = parsedCSV[Token.Password] else {
                    continue
            }
            let account = Account(userName: userName, password: password)
            
            guard var accounts = structure[environment] else {
                structure[environment] = [account]
                continue
            }
            accounts.insert(account)
        }
        
        self.init(accounts: structure)
    }
}