//
//  StringExtension.swift
//  Snakey List
//
//  Created by Ali Adam on 1/27/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//


import UIKit

extension String {
    /// match this string with regex pattern
    ///
    /// - Parameter regex: regex pattern
    /// - Returns: bool value indicate if it match or not
    func matchRegex(regex : String ) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// cheack if this string is availd url or not
    ///
    /// - Returns:  Returns: bool value indicate if it url or not
    func isValidURL() -> Bool {
        let regex : String = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        return self.matchRegex(regex: regex)
    }
    
    /// cheack if this string is availd UUID or not
    ///
    /// - Returns:  Returns: bool value indicate if it UUID or not
    
    func isValidUUID() -> Bool {
        let regex : String = "[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}"
        return self.matchRegex(regex: regex)
    }
    //
    static func randomUUID() -> String {
     return UUID().uuidString
    }
}
