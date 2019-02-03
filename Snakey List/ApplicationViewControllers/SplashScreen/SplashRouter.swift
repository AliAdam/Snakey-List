//
//  SplashRouter.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright (c) 2018 Ali Adam. All rights reserved.
//

import Foundation
import  UIKit
class SplashRouter:NSObject {
    
    weak var splashViewController: SplashViewController?
    
    override init() {
        super.init()
    }
    // navigate to next screen collection screen
    func navigateToItemsGridList() {
        let viewModel = ItemsGridViewModel(itemList: splashViewController!.getItemList())
        let  viewController = StoryboardScene.ItemsGridViewController.initialViewController() as! ItemsGridViewController
        viewController.setViewModel(viewModel: viewModel)
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    // show alert controller
    func showParsingErrorAlert() {
        AlertControllerHelper.showAlert(withTitle: LocalizableWords.errorMessageTile, message: LocalizableWords.parseErrorMessage, on: splashViewController!)
    }
}
