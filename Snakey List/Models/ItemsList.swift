
//
//  ItemsList.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//


import Foundation
/// item list model contain list of items
struct ItemsList : Codable {
    var items : [Item]?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([Item].self, forKey: .items)
    }
    
    mutating func deleteItem (atIndex index:Int){
        var it = items
        it?.remove(at: index)
        items = it
    }
    mutating func changeUUIdForItem (atIndex index:Int,newUUID uuid:String){
        var it = items
        let oldItem = it![index]
        let json = """
            {
            "uuid": "\(uuid)",
            "imageUrlString": "\(oldItem.imageUrlString ?? "")"
            }
            """.data(using: .utf8)!
        let item = try! JSONDecoder().decode(Item.self, from: json)
        it?.remove(at: index)
        it?.insert(item, at: index)
        items = it
    }
    mutating func addItemWith(uuid:String, imageurl url:String){
        var it = items
        
        let json = """
            {
            "uuid": "\(uuid)",
            "imageUrlString": "\(url)"
            }
            """.data(using: .utf8)!
        let item = try! JSONDecoder().decode(Item.self, from: json)
        it?.append(item)
        items = it
    }
    
    mutating func moveItem( fromIndex: Int, toIndex: Int)
    {
        var it = items
        let oldItem = it![fromIndex]
        it?.remove(at: fromIndex)
        it?.insert(oldItem, at: toIndex)
        items = it
    }
    
}
