//
//  SnakeUICollectionLayout.swift
//  Snakey List
//
//  Created by Ali Adam on 1/27/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//

import UIKit

/// SnakeUICollectionLayout this is how i draw the layout of collection view and handle drag and drop
class SnakeUICollectionLayout: UICollectionViewLayout {
    
    typealias IndexAndItems = (index:Int, item:Int) // reprsnt item and it's index on the row
    typealias RowIndexAndItems = (row:Int, rowItem:IndexAndItems) // repesnt the index of the row and item on it
    
    // compilation handler called after drag end
    var didReorderHandler: (_ fromIndexPath: IndexPath, _ toIndexPath: IndexPath) -> Void = { _, _ in }
    
    fileprivate var longPressGestureRecognizer = UILongPressGestureRecognizer()
    fileprivate var panGestureRecognizer = UIPanGestureRecognizer()
    // view that contain snapshot of the cell
    fileprivate var dragView: DraggingView?
    // array contain index of pathes to animate delete or insert
    private var indexPathsToAnimate = [IndexPath]()
    
    // index for paths to move
    private var indexPathsToMove = [IndexPath]()
    
    fileprivate var numberOfColumns = 3
    fileprivate var cellPadding: CGFloat = 0
    
    // Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //Content height and size
    fileprivate var contentHeight: CGFloat = 0
    
    var rows : [RowIndexAndItems] = []
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    
    override init() {
        super.init()
        addObserver(self, forKeyPath: "collectionView", options: [], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObserver(self, forKeyPath: "collectionView", options: [], context: nil)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "collectionView", context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "collectionView" {
            // add gest to the collection view
            setupGestureRecognizers()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func prepare() {
        cache.removeAll()
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        // Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset  = [CGFloat](repeating: 0, count: numberOfColumns)
        contentHeight = 0
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        //  Iterates through the list of items in the first section
        var index = 0
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            // Pre-Calculates the position of each item in column and row
            if item % 3 == 0 || item == 0
            {
                let i = item
                index = index + 1
                if  index % 2 != 0 {
                    
                    rows.append(RowIndexAndItems(index,IndexAndItems(0,i)))
                    rows.append(RowIndexAndItems(index,IndexAndItems(1,i+1)))
                    rows.append(RowIndexAndItems(index,IndexAndItems(2,i+2)))
                }
                else
                {
                    rows.append(RowIndexAndItems(index,IndexAndItems(0,i+2)))
                    rows.append(RowIndexAndItems(index,IndexAndItems(1,i+1)))
                    rows.append(RowIndexAndItems(index,IndexAndItems(2,i)))
                    
                }
            }
            let indexPath = IndexPath(item: item, section: 0)
            let height = cellPadding * 2 + columnWidth
            let  rowIndexAndItems = rows.filter({$0.rowItem.item == item})
            var frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            if item == 0 {
                xOffset[column] = 0
                yOffset[column] = 0
                frame =   CGRect(x: 0, y:0,
                                 width: columnWidth * 2 , height: columnWidth * 2)
                
            }
            else if item ==  1 {
                xOffset[column] = columnWidth * 2
                yOffset[column] = 0
                
                frame =   CGRect(x: columnWidth * 2, y:0,
                                 width: columnWidth  , height: columnWidth )
                
            }
            else if item == 2 {
                xOffset[column] = columnWidth * 2
                yOffset[column] = columnWidth
                
                frame =   CGRect(x: columnWidth * 2, y:columnWidth,
                                 width: columnWidth  , height: columnWidth )
                
            }
            else if let item = rowIndexAndItems.first {
                let x = CGFloat(item.rowItem.index) * columnWidth
                let y =   CGFloat ((rowIndexAndItems.first?.row)!) * columnWidth
                
                xOffset[column] = x
                yOffset[column] = y
                
                frame =  CGRect(x: x, y: y, width: columnWidth , height: columnWidth )
            }
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            // Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Updates the collection view content height
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
            return nil
        }
        
        guard indexPathsToAnimate.contains(itemIndexPath) else {
            if let index = indexPathsToMove.index(of: itemIndexPath) {
                indexPathsToMove.remove(at: index)
                attributes.alpha = 1.0
                return attributes
            }
            return nil
        }
        
        if let index = indexPathsToAnimate.index(of: itemIndexPath) {
            indexPathsToAnimate.remove(at: index)
        }
        
        // insert animation
        attributes.alpha = 1.0
        attributes.center = CGPoint(x: collectionView!.frame.width - 23.5, y: -24.5)
        attributes.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
        attributes.zIndex = 99
        
        
        return attributes
    }
    
    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else {
            return nil
        }
        
        // in case if move animation
        guard indexPathsToAnimate.contains(itemIndexPath) else {
            if let index = indexPathsToMove.index(of: itemIndexPath) {
                indexPathsToMove.remove(at: index)
                attributes.alpha = 1.0
                attributes.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
                attributes.zIndex = -1
                return attributes
            }
            return nil
        }
        
        if let index = indexPathsToAnimate.index(of: itemIndexPath) {
            indexPathsToAnimate.remove(at: index)
        }
        // delete animation
        attributes.alpha = 1.0
        attributes.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
        attributes.zIndex = -1
        
        return attributes
    }
    
    open override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        var currentIndexPath: IndexPath?
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                currentIndexPath = updateItem.indexPathAfterUpdate
            case .delete:
                currentIndexPath = updateItem.indexPathBeforeUpdate
            case .move:
                currentIndexPath = nil
                indexPathsToMove.append(updateItem.indexPathBeforeUpdate!)
                indexPathsToMove.append(updateItem.indexPathAfterUpdate!)
            default:
                currentIndexPath = nil
            }
            
            if let indexPath = currentIndexPath {
                indexPathsToAnimate.append(indexPath)
            }
        }
    }
}


// MARK: - UIGestureRecognizerDelegate
extension SnakeUICollectionLayout : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == longPressGestureRecognizer && otherGestureRecognizer == panGestureRecognizer {
            return true
        } else if gestureRecognizer == panGestureRecognizer {
            return otherGestureRecognizer == longPressGestureRecognizer
        }
        
        return true
    }
    
    // check f item can moved or not this to prevnt move of add cell
    func canMoveItemAtIndexPath(_ indexPath: IndexPath) -> Bool {
        if indexPath.item ==  (collectionView?.numberOfItems(inSection: 0))! - 1{
            return false
        }
        return  true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == longPressGestureRecognizer {
            let location = gestureRecognizer.location(in: collectionView)
            if let indexPath = collectionView?.indexPathForItem(at: location), !canMoveItemAtIndexPath(indexPath) {
                return false
            }
        }
        
        let states: [UIGestureRecognizerState] = [.possible, .failed]
        if gestureRecognizer == longPressGestureRecognizer && !states.contains(collectionView!.panGestureRecognizer.state) {
            return false
        } else if gestureRecognizer == panGestureRecognizer && states.contains(longPressGestureRecognizer.state) {
            return false
        }
        
        return true
    }
    
    // MARK: -  handleLongPressGestureRecognized  methods get acopy of the draged cell  and move it at end call the handler
    @objc func handleLongPressGestureRecognized(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: collectionView)
            if let indexPath = collectionView!.indexPathForItem(at: location), let cell = collectionView!.cellForItem(at: indexPath) {
                dragView?.removeFromSuperview()
                let newDragView = DraggingView(cell: cell as! ItemCell)
                newDragView.dragIndexPath = indexPath
                newDragView.initialCenter = cell.center
                newDragView.dragCenter = cell.center
                newDragView.center = newDragView.dragCenter
                newDragView.fromIndexPath = indexPath
                dragView = newDragView
                collectionView?.addSubview(dragView!)
                invalidateLayout()
                UIView.animate(withDuration: 0.16, animations: {
                    self.dragView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
            }
        case .ended:
            if let finalDragView = self.dragView {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                    finalDragView.center = finalDragView.dragCenter
                    finalDragView.transform = CGAffineTransform.identity
                }, completion: { _ in
                    finalDragView.removeFromSuperview()
                    if let fromIndexPath = finalDragView.fromIndexPath, let toIndexPath = finalDragView.toIndexPath {
                        if toIndexPath.item !=  (self.collectionView?.numberOfItems(inSection: 0))! - 1{
                            self.didReorderHandler(fromIndexPath, toIndexPath)
                        }
                    }
                    self.dragView = nil
                    self.invalidateLayout()
                })
            }
        default:
            break
        }
    }
    
    @objc func handlePanGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: collectionView!)
        switch recognizer.state {
        case .changed:
            if let newDragView = dragView {
                newDragView.center.x = newDragView.initialCenter.x + translation.x
                newDragView.center.y = newDragView.initialCenter.y + translation.y
                if let _ = newDragView.dragIndexPath,
                    let toIndexPath = collectionView!.indexPathForItem(at: newDragView.center),
                    let targetLayoutAttributes = layoutAttributesForItem(at: toIndexPath) {
                    
                    newDragView.dragIndexPath = toIndexPath
                    newDragView.dragCenter = targetLayoutAttributes.center
                    newDragView.bounds = targetLayoutAttributes.bounds
                    newDragView.toIndexPath = toIndexPath
                }
            }
        default:
            break
        }
    }
    
    /// add gest to collection
    fileprivate func setupGestureRecognizers() {
        if let _ = self.collectionView {
            collectionView!.removeGestureRecognizer(longPressGestureRecognizer)
            collectionView!.removeGestureRecognizer(panGestureRecognizer)
            
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognized(_:)))
            longPressGestureRecognizer.delegate = self
            collectionView!.addGestureRecognizer(longPressGestureRecognizer)
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognized(_:)))
            panGestureRecognizer.delegate = self
            panGestureRecognizer.maximumNumberOfTouches = 1
            collectionView!.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
}


