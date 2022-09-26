//
//  ItemDetailsCell.swift
//  AuthenticationModule
//
//  Created by Ahmed Tarek on 12/29/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

// MARK: Delegate
protocol ItemDetailsCellDelegate: class {
    func didTapRemove(at cell: ItemDetailsCell)
    func didTapOpen(at cell: ItemDetailsCell)
}

class ItemDetailsCell: BaseUICollectionViewCell {
    
    // MARK: Variables
    weak var delegate: ItemDetailsCellDelegate?

    // MARK: Outlets
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var removeButton: UIView!
    
    // MARK: Functions
    override func setupViews() {
    
    }
    
    override func setupTitles() {
        
    }
    
    override func didLayoutSuccessfully() {
        selectedImageView.setCircle()
    }
    
    override func viewsGesturesRelations() -> [UIView: Selector] {
        return [
            removeButton: #selector(removeAction),
            nameLabel: #selector(openAction),
            selectedImageView: #selector(openAction)
        ]
    }
    
    @objc func removeAction() {
        delegate?.didTapRemove(at: self)
    }
    
    @objc func openAction() {
        delegate?.didTapOpen(at: self)
    }
    
}

// MARK: Binders
extension ItemDetailsCell {
    func bind(item: ItemDisplayable) {
        selectedImageView.isHidden = item is FileDisplayable
       
        item.display(in: selectedImageView)
        item.display(in: nameLabel)
    }

}
