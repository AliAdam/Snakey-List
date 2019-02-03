//
//  ItemsGridRouter.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright (c) 2018 Ali Adam. All rights reserved.
//

import Foundation
import UIKit

class ItemsGridRouter :NSObject {
    weak var itemsGridViewController: ItemsGridViewController?
    
    // delete confirmation alert
    func showDeleteConfirmationWith(uuid:String, completionHandler: @escaping (ConfirmResponse<Bool>) -> ()){
        let alertController = UIAlertController(title: LocalizableWords.deleteTitle, message: "\(LocalizableWords.deleteConfrimation)\(uuid)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizableWords.yes, style: .default) { (action) in
            completionHandler(.confirm(true))
        }
        let cancelAction = UIAlertAction(title: LocalizableWords.cancel, style: .default) { (action) in
            completionHandler(.notConfirm(true))
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        itemsGridViewController?.present(alertController, animated: true, completion: nil)
        
        
    }
    
    // Delete Error Alert
    func showDeleteErrorAlert() {
        AlertControllerHelper.showAlert(withTitle: LocalizableWords.errorMessageTile, message: LocalizableWords.deleteErrorMessage, on: itemsGridViewController!)
    }
    
    // Update Error Alert
    func showUpdateErrorAlert() {
        AlertControllerHelper.showAlert(withTitle: LocalizableWords.errorMessageTile, message: LocalizableWords.updateErrorMessage, on: itemsGridViewController!)
    }
    // reorder Error Alert
    func showReorderErrorAlert() {
        AlertControllerHelper.showAlert(withTitle: LocalizableWords.errorMessageTile, message: LocalizableWords.reorderErrorMessage, on: itemsGridViewController!)
    }
    
    // add new item  Alert
    func  showAddNewItemAlert(completionHandler: @escaping (ConfirmResponse<String>) -> ())  {
        let alertController = UIAlertController(title: LocalizableWords.addNewItemTile, message: LocalizableWords.addNewItemMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizableWords.yes, style: .default) { (action) in
            let textField = alertController.textFields![0] as UITextField
            completionHandler(.confirm(textField.text!))
        }
        let cancelAction = UIAlertAction(title: LocalizableWords.cancel, style: .default) { (action) in
            completionHandler(.notConfirm(""))
        }
        okAction.isEnabled = false
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = LocalizableWords.addNewItemMessage
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                okAction.isEnabled = textField.text!.isValidURL()
            }
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        itemsGridViewController?.present(alertController, animated: true, completion: nil)
    }
    
    
    //  change UUID  Alert
    
    func  showChangeUUIDAlert(uuid:String,completionHandler: @escaping (ConfirmResponse<String>) -> ())  {
        
        let message = LocalizableWords.changeUUIDMessage.replacingOccurrences(of: LocalizableWords.placeHolderUUID, with: uuid)
        let alertController = UIAlertController(title: LocalizableWords.changeUUIDTile, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: LocalizableWords.change, style: .default) { (action) in
            let textField = alertController.textFields![0] as UITextField
            completionHandler(.confirm(textField.text!))
        }
        let cancelAction = UIAlertAction(title: LocalizableWords.cancel, style: .default) { (action) in
            completionHandler(.notConfirm(""))
        }
        okAction.isEnabled = false
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = LocalizableWords.placeHolderUUID
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                okAction.isEnabled = textField.text!.isValidUUID()
            }
            
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        itemsGridViewController?.present(alertController, animated: true, completion: nil)
    }
}
