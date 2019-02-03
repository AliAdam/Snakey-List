//
//  NetworkProvider.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//


import UIKit

/// shard singlton act like a network layer get and update the data
struct NetworkProvider {
    static let shared = NetworkProvider()
    
    private init() {
    }
    /// get list of items
    ///
    func itemList(completionHandler: @escaping (NetworkResponse<ItemsList>) -> ()){
        guard  let data =  MockLoader.itemsListMock  else {
            completionHandler(.error(APPError.couldNotLoadMock))
            return
        }
        do{
            let decoder = JSONDecoder()
            let itemsList = try decoder.decode(ItemsList.self, from: data)
            completionHandler(.success(itemsList))
        } catch {
            completionHandler(.error(APPError.couldNotParseJson))
        }
        
        
        
    }
    /// update items list with new values 
    func updateItemList(with itemsList: ItemsList,completionHandler: @escaping (NetworkResponse<Bool>) -> ()){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(itemsList)
            let saved = MockLoader.updateitems(data)
            completionHandler(.success(saved))
        } catch {
            completionHandler(.error(APPError.couldNotUpdate))
        }
    }
}
