//
//  AlertControllerHelper.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//

import UIKit

final class AlertControllerHelper {
    
    private init() {}
    // show quick alert with title and message and okay button 
    static func showAlert(withTitle title: String, message: String?, on viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: LocalizableWords.ok, style: .default))
        viewController.present(alertController, animated: true)
    }
}
