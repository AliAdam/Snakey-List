//
//  AsyncImageDownloader.swift
//  AsyncImageDownloader
//
//  Created by Ali Adam on 7/12/17.
//  Copyright © 2017 Ali Adam. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

/// this class to load and cash images
class AsyncImageDownloader: NSObject {
    static let `default` = AsyncImageDownloader()
    
    private let cache = NSCache<AnyObject,AnyObject>()
    
    /// CashImage init method
    ///
    override init() {
        cache.name = "AsyncImageDownloader"
        cache.countLimit = 20
        cache.totalCostLimit = 15
    }
    /// load image from cach
    ///
    /// - Parameter key: key
    /// - Returns: image
    private func getImageFor(key :String) -> UIImage? {
        let image =  cache.object(forKey:key as AnyObject) as? UIImage
        return image
    }
    
    /// save image to cach
    ///
    /// - Parameters:
    ///   - image: image to be save
    ///   - key: key
    private func saveImage(image : UIImage ,key :String) {
        cache.setObject(image, forKey:key as AnyObject)
    }
    
    /// load the image and save it to the cash or load it from the cash
    ///
    /// - Parameters:
    ///   - imageView: imageView to add the image on it
    ///   - url: image url
    func load(imageView : UIImageView ,url :String) {
        
        /// showActivityIndicator method you can find it on UIImageView+Extension.swift
        /// i add this method  to  UIImageView class you can show and hide
        /// ActivityIndicator on any imageview  with easy way
        
        /// check if image cached or not if exist load it from the cach if not load it
        if  AsyncImageDownloader.default.getImageFor(key: url) != nil{
            if let image =  AsyncImageDownloader.default.getImageFor(key: url){
                imageView.image = image
                imageView.hideActivityIndicator()
            }
        }
        else{
            AsyncImageDownloader.default.loadImageFor(imageView:imageView,url: url)
        }
    }
    
    
    /// load image from server
    ///
    /// - Parameters:
    ///   - imageView: imageView to add the image on it
    ///   - url: image url
    func loadImageFor(imageView : UIImageView ,url :String){
        let imageURL = URL(string: url)
        if let imgurl = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: imgurl)
                DispatchQueue.main.async {
                    if imageData != nil {
                        if let image = UIImage(data: imageData! as Data) {
                            imageView.image = image
                            AsyncImageDownloader.default.saveImage(image: image ,key: url)
                            imageView.hideActivityIndicator()
                        }
                    }
                }
            }
        }
    }
}



