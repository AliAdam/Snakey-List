//
//  SplashViewController.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright (c) 2018 Ali Adam. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController  {
    // controller view model
    @IBOutlet var viewModel: SplashViewModel!
    
    // contrroler router to navigate to other controller or show messages
    @IBOutlet var router: SplashRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the router controller
        router.splashViewController = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    /// load item list and navigate to collection view on sucess
    // show error on fail
    func loadData()  {
        viewModel.loadItemsList { [weak self] response in
            switch response {
            case .success(_):
                self?.router.navigateToItemsGridList()
                
            case .error( _):
                self?.router.showParsingErrorAlert()
            }
        }
    }
    
    /// get item list to pass it to the new viewmodel of next screen
    func getItemList() -> ItemsList {
        return viewModel.getItemList()
    }
}
