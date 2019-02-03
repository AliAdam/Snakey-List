//
//  ItemCell.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var  isAddView = false
    // add btn complation handler
    var addBTNHandler: (_ index :Int , _ cell:ItemCell) -> Void = { _,_ in  }
   
    // delete btn complation handler
    var deleteBTNHandler: (_ index :Int , _ cell:ItemCell) -> Void = { _,_ in  }

    @IBOutlet weak var addBTN: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBTN.titleLabel?.lineBreakMode = .byWordWrapping
        addBTN.titleLabel?.numberOfLines = 2
        addBTN.titleLabel?.textAlignment = .center;
        addBTN.setTitle(" + \nAdd ", for: .normal)
        addBTN.backgroundColor = .blue
        
    }
    
    /// config the cell and load the image
    ///
    /// - Parameters:
    ///   - imageUrlString: image url
    ///   - index: index of cell
    ///   - isAdd: is it the add cell or not
    func Config(imageUrlString: String ,index: Int ,isAdd:Bool) {
        self.imageView.tag = index
        self.imageView.image = #imageLiteral(resourceName: "placeholder")
        if (isAdd) {
            deleteBTN.isHidden = true
            imageView.isHidden = true
            addBTN.setTitle(" + \nAdd ", for: .normal)
            addBTN.backgroundColor = .gray
        }
        else {
            deleteBTN.isHidden = false
            imageView.isHidden = false
            addBTN.setTitle("", for: .normal)
            addBTN.backgroundColor = .clear
            imageView.loadImageFromUrl(imageUrlString, withActivityIndicator: .whiteLarge, andCach: true)
        }
    }
  
    @IBAction func deleteBTNAction(_ sender: Any) {
        self.deleteBTNHandler(self.imageView.tag,self)
    }
    @IBAction func addBTNAction(_ sender: Any) {
    
        self.addBTNHandler(self.imageView.tag,self)
    }
    
    // return drag view contain snap shot of the cell 
    func dragView() -> UIView {
        var dragViewFrame = self.imageView.bounds
        dragViewFrame.origin.x = (bounds.size.width - dragViewFrame.size.width) / 2
        dragViewFrame.origin.y = (bounds.size.height - dragViewFrame.size.height) / 2
        let dragView = UIView(frame: dragViewFrame)
        dragView.clipsToBounds = true
        let imageRect = CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.width)
        let imageView = UIImageView(frame: imageRect)
        imageView.image = self.contentView.takeSnapshot()
        imageView.contentMode = self.imageView.contentMode
        imageView.clipsToBounds = true
        dragView.addSubview(imageView)
        imageView.bindFrameToSuperviewBounds()
        dragView.transform = contentView.transform
        return dragView
    }
}
