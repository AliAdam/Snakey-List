//
//  ItemsGridViewModel.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright (c) 2018 Ali Adam. All rights reserved.
//

import Foundation

class ItemsGridViewModel:NSObject {
    
    fileprivate var itemsList : ItemsList?
    
    override init() {
        super.init()
    }
    // init the view model with list of item
    init(itemList:ItemsList) {
        super.init()
        self.itemsList = itemList
    }
    
    // return item count
    var itemsCount: Int? {
        return itemsList?.items?.count
    }
    
    //    // items array
    //    var items: [Item]? {
    //        return itemsList?.items
    //    }
    
    // image url for item at index
    func imageURLForItemAt(index:Int) -> String {
        return (self.itemsList?.items![index].imageUrlString)!
    }
    
    // UUID for item at index
    func uuidForItemAt(index:Int) -> String {
        return (self.itemsList?.items![index].uuid)!
    }
    
    // return item at index
    func itemAt(index:Int) -> Item {
        return (self.itemsList?.items![index] )!
    }
    
    
    /// add new item with with url and generate uuid for it then update the saved data ince sucess call the complation handler
    func addNewItem(url:String,completionHandler:@escaping (NetworkResponse<Item>)->()){
        let tempItemList = self.itemsList
        let randomUUID = String.randomUUID()
        self.itemsList?.addItemWith(uuid: randomUUID, imageurl: url)
        let lastIndex = self.itemsCount! - 1
        let item = self.itemAt(index: lastIndex)
        NetworkProvider.shared.updateItemList(with: self.itemsList!) { [weak self] response in
            switch response {
            case .success(_):
                completionHandler(.success(item))
            case let  .error(error):
                self?.itemsList = tempItemList
                completionHandler(.error(error))
                
            }
            
        }
    }
    
    /// delet itemthen update the saved data ince sucess call the complation handler
    func deleteItem (atIndex index:Int,completionHandler:@escaping (NetworkResponse<Bool>)->()){
        let tempItemList = self.itemsList
        self.itemsList?.deleteItem(atIndex: index)
        NetworkProvider.shared.updateItemList(with: self.itemsList!) { [weak self] response in
            switch response {
            case let  .success(res):
                completionHandler(.success(res))
            case let  .error(error):
                self?.itemsList = tempItemList
                completionHandler(.error(error))
            }
            
        }
    }
    
    /// change uuid for item then update the saved data ince sucess call the complation handler
    
    func changeUUIdForItem (atIndex index:Int,newUUID uuid:String,completionHandler:@escaping (NetworkResponse<Bool>)->()){
        let tempItemList = self.itemsList
        self.itemsList?.changeUUIdForItem(atIndex: index, newUUID: uuid)
        NetworkProvider.shared.updateItemList(with: self.itemsList!) { [weak self] response in
            switch response {
            case let  .success(res):
                completionHandler(.success(res))
            case let  .error(error):
                self?.itemsList = tempItemList
                completionHandler(.error(error))
            }
            
        }
    }
    
    /// move  item from index to index  then update the saved data ince sucess call the complation handler
    func moveItem( fromIndex: Int, toIndex: Int,completionHandler:@escaping (NetworkResponse<Bool>)->()){
        let tempItemList = self.itemsList
        self.itemsList?.moveItem(fromIndex: fromIndex, toIndex: toIndex)
        NetworkProvider.shared.updateItemList(with: self.itemsList!) { [weak self] response in
            switch response {
            case let  .success(res):
                completionHandler(.success(res))
            case let  .error(error):
                self?.itemsList = tempItemList
                completionHandler(.error(error))
            }
            
        }
    }
    
    
}


