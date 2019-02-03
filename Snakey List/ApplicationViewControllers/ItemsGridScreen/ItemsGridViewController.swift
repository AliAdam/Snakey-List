//
//  ItemsGridViewController.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright (c) 2018 Ali Adam. All rights reserved.
//

import UIKit

class ItemsGridViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    // controller view model
    @IBOutlet var viewModel: ItemsGridViewModel!
    
    // contrroler router to navigate to other controller or show messages
    @IBOutlet var router: ItemsGridRouter!
    
    
    // set the viewmodel
    func setViewModel(viewModel:ItemsGridViewModel)  {
        self.viewModel = viewModel
    }
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        router.itemsGridViewController = self
       
        // config the collectionView Lay out
        configCollectionView()
        
        
    }
    
    
    func configCollectionView()  {
        
        // set the SnakeUICollectionLayout completion handler to call it when
        // move cell
        let layout = collectionView.collectionViewLayout as! SnakeUICollectionLayout
        layout.didReorderHandler = { [weak self] fromIndexPath, toIndexPath in
            self?.moveItem(fromIndex: fromIndexPath.item, toIndex: toIndexPath.item)
        }
        collectionView.reloadData()
    }
    
}

//MARK:- UICollectionViewDelegate
extension ItemsGridViewController : UICollectionViewDelegate ,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configCellForItem(item: indexPath.item, andCell: cell)
        return cell
    }
    
    // config each cell by the item from list
    func configCellForItem(item:Int,andCell cell:ItemCell?)  {
        if let itemCell = cell {
            var isAdd = false
            if item == viewModel.itemsCount!  {
                isAdd = true
                itemCell.addBTNHandler = { [weak self] index ,cell in
                    self?.addItemAction(index: index)
                }
                itemCell.Config(imageUrlString: "" ,index: item ,isAdd:isAdd )
            }
            else {
                let url = viewModel.imageURLForItemAt(index: item)
                itemCell.Config(imageUrlString: url ,index: item ,isAdd:isAdd )
                itemCell.addBTNHandler = { [weak self] index,cell in
                    let indexpath =  self?.collectionView.indexPath(for: cell)
                    self?.changeItemIDAction(index: (indexpath?.item)!)
                }
                itemCell.deleteBTNHandler = { [weak self] index,cell in
                    let indexpath =  self?.collectionView.indexPath(for: cell)
                    self?.deleteItemAction(index: (indexpath?.item)!)
                }
            }
            
        }
    }
}
//MARK:- Delete,Add,Move,Change  Actions

extension ItemsGridViewController {
    
    
    // MARK: -  delete action
    
    // confirm action from user then delete item from the list by view model
    // then update the collection view on success
    func deleteItemAction(index :Int) {
        let uuid = viewModel.uuidForItemAt(index: index)
        router.showDeleteConfirmationWith(uuid:uuid, completionHandler: { [weak self] response in
            switch response {
            case .confirm(_):
                self?.deleteItemAt(index: index)
            case .notConfirm(_):
                print("not confirm ")
            }
        })
    }
    func deleteItemAt(index :Int)  {
        self.viewModel.deleteItem(atIndex: index) { [weak self] response in
            switch response {
            case .success(_):
                print("")
                self?.removeItemFromCollection(index: index)
            case .error(_):
                self?.router.showDeleteErrorAlert()
                
            }
        }
    }
    func removeItemFromCollection(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
        })
    }
    
    
    //MARK:- add item Action
    
    // confirm action from user then add item to  the list by view model
    // then update the collection view on success
    
    func addItemAction(index :Int) {
        self.router.showAddNewItemAlert { [weak self] response in
            switch response {
            case let .confirm(url):
                self?.addItemWith(url: url)
                print("\(url)")
            case .notConfirm(_):
                print("not Confirm")
            }
            
        }
    }
    func addItemWith(url :String)  {
        self.viewModel.addNewItem(url: url){ [weak self] response in
            switch response {
            case .success(_):
                self?.insertItemToCollection(index:((self?.viewModel.itemsCount!)! - 1))
            case .error(_):
                self?.router.showDeleteErrorAlert()
                
            }
        }
    }
    func insertItemToCollection(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
        })
    }
    
    //MARK:- change UUID Action
    
    // confirm action from user then chnge  uuid  on  the list by view model
    // then update the collection view on success
    func changeItemIDAction(index :Int) {
        print("\(index)")
        let itemUUId = self.viewModel.uuidForItemAt(index: index)
        self.router.showChangeUUIDAlert(uuid:itemUUId){ [weak self] response in
            switch response {
            case let .confirm(uuid):
                self?.changeUUIdForItem(atIndex: index, newUUID: uuid)
                print("\(uuid)")
            case .notConfirm(_):
                print("not Confirm")
            }
            
        }
    }
    
    func changeUUIdForItem (atIndex index:Int,newUUID uuid:String)  {
        self.viewModel.changeUUIdForItem(atIndex:index,newUUID:uuid){ [weak self] response in
            switch response {
            case .success(_):
                let selectedIndexPath = IndexPath(item: index, section: 0)
                self?.collectionView.reloadItems(at: [selectedIndexPath])
            case .error(_):
                self?.router.showDeleteErrorAlert()
                
            }
        }
    }
    
    
    //MARK:- move item from index to index
    
    // move   item to the new index on  the list by view model
    // then update the collection view on success
    func moveItem( fromIndex: Int, toIndex: Int) {
        self.viewModel.moveItem(fromIndex:fromIndex,toIndex:toIndex){ [weak self] response in
            switch response {
            case .success(_):
                self?.moveItemInCollection(fromIndex:fromIndex, toIndex: toIndex)
            case .error(_):
                self?.router.showReorderErrorAlert()
            }
        }
    }
    func moveItemInCollection( fromIndex: Int, toIndex: Int) {
        let fromIndexPath = IndexPath(item: fromIndex, section: 0)
        let toIndexPath = IndexPath(item: toIndex, section: 0)
        
        collectionView?.performBatchUpdates({
            self.collectionView?.moveItem(at: fromIndexPath, to: toIndexPath)
        }, completion: nil
        )
    }
}





