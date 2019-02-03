//
//  SplashViewModel.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright (c) 2018 Ali Adam. All rights reserved.
//

import  Foundation
class SplashViewModel :NSObject{

    fileprivate var itemsList : ItemsList?
    override init() {
        super.init()
    }
    // load item list
    func loadItemsList(completionHandler: @escaping (NetworkResponse<Bool>) -> ()){
        NetworkProvider.shared.itemList { [weak self] response in
            switch response {
            case let .success(itemList):
                self?.itemsList = itemList
                completionHandler(.success(true))
                print("items count = \(String(describing: itemList.items?.count))")
            case let .error(error):
                completionHandler(.error(error))
                print("\(error.localizedDescription)")
            }
        }
        
    }
    
    /// get item list
    func getItemList() -> ItemsList {
        return itemsList!
    }
    
    
}


