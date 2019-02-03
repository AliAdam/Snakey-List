//
//  DraggingView.swift
//  Snakey List
//
//  Created by Ali Adam on 1/28/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//

import UIKit


/// view used for dragging contain snapshot of the item
class DraggingView: UIView {
    var dragIndexPath: IndexPath? // Current indexPath
    var dragCenter = CGPoint.zero // point being dragged from
    var fromIndexPath: IndexPath? // Original index path
    var toIndexPath: IndexPath? // index path the dragView was dragged to
    var initialCenter = CGPoint.zero
    
    init(cell: ItemCell) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        autoresizingMask = cell.autoresizingMask
        clipsToBounds = true
        frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
        let dragView = cell.dragView()
        addSubview(dragView)
        dragView.bindFrameToSuperviewBounds()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

