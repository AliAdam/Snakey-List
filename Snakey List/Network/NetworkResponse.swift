//
//  NetworkResponse.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//


/// respnse enumration
///
/// - error: in case error occure pass the error
/// - success: in success case pass the object to it
enum NetworkResponse<Element> {
    case error(Error)
    case success(Element)
    
}
/// enum repsent user response if he confirm to do some thing or not
///
enum ConfirmResponse<Element> {
    case notConfirm(Element)
    case confirm(Element)
    
}
