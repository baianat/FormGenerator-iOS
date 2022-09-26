//
//  VerticalItemsAdapter.swift
//  AuthenticationModule
//
//  Created by Ahmed Tarek on 12/29/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

protocol VerticalItemsAdapterDelegate: class {
    func didTapOpenItem(item: ItemDisplayable)
    func didRemoveAllItems()
    func didRemoveItem()
}

class VerticalItemsAdapter: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    weak var delegate: VerticalItemsAdapterDelegate?
    
    private(set) var items: [ItemDisplayable] = []
     
    func initialize(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView.registerCell(cellType: ItemDetailsCell.self)
    }
    
    func update(items: [ItemDisplayable]) {
        self.items = items
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func append(items: [ItemDisplayable]) {
        var newItems = items
        newItems.removeAll { (newItem) -> Bool in
            self.items.contains { (item) -> Bool in
                item.url?.path == newItem.url?.path
            }
        }
        if newItems.isEmpty {
            return
        }
        
        let start = self.items.count
        
        self.items.append(contentsOf: newItems)
        let indices = (start ..< (start + newItems.count)).map { (index) in
            return IndexPath(row: index, section: 0)
        }
        collectionView.insertItems(at: indices)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ItemDetailsCell(), forIndex: indexPath)
        cell.delegate = self
        cell.bind(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = CGFloat(48)
        let width = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
}

extension VerticalItemsAdapter: ItemDetailsCellDelegate {
    func didTapRemove(at cell: ItemDetailsCell) {
        if let index = collectionView.indexPath(for: cell) {
            items.remove(at: index.row)
            delegate?.didRemoveItem()
            if items.isEmpty {
                delegate?.didRemoveAllItems()
            } else {
                collectionView.deleteItems(at: [index])
            }
        }
    }
    
    func didTapOpen(at cell: ItemDetailsCell) {
        if let index = collectionView.indexPath(for: cell) {
            delegate?.didTapOpenItem(item: items[index.row])
        }
    }
}
