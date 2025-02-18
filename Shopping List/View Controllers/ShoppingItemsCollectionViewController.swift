//
//  ShoppingItemsCollectionViewController.swift
//  Shopping List
//
//  Created by Angelique Abacajan on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ShoppingItemsCollectionViewController: UICollectionViewController {
    
    struct PropertyKeys {
        static let itemCell = "ItemCell"
        static let orderSegue = "ShowSubmitOrderSegue"
        static let addedHeader = "AddedHeader"
    }
    
    let shoppingItemController = ShoppingItemController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingItemController.fetchItems()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let submitOrderViewController = segue.destination as? PlaceOrderViewController else { return }
        placeOrderViewController.itemCount = shoppingItemController.shoppingItems.filter( {$0.added} ).count
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section {
        case 0:
            print(shoppingItemController.notAddedShoppingItems.count)
            return shoppingItemController.addedShoppingItems.count
        default:
            return shoppingItemController.notAddedShoppingItems.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.itemCell, for: indexPath) as? ShoppingItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.shoppingItem = itemFor(indexPath)
    
        return cell
    }
    
    private func itemFor(_ indexPath: IndexPath) -> ShoppingItem {
        switch indexPath.section {
        case 0:
            return shoppingItemController.addedShoppingItems[indexPath.item]
        default:
            return shoppingItemController.notAddedShoppingItems[indexPath.item]
        }
    }
}

extension ShoppingItemsCollectionViewController: ShoppingItemCollectionViewCellDelegate {
    func ItemTapped(forItem item: ShoppingItemCollectionViewCell) {
        guard let shoppingItem = item.shoppingItem else { return }
        
        shoppingItemController.itemAddedToggled(for: shoppingItem)
        collectionView!.reloadData()
    }
}
