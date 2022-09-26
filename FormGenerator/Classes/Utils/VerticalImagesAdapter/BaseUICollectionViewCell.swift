//
//  BaseUICollectionViewCell.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 29/03/2021.
//

import UIKit

class BaseUICollectionViewCell: UICollectionViewCell {
    
    static var id: String {
        String.init(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTitles()
        setupViews()
        addTapGestures()
    }
    
    func setupTitles() {
        
    }
    
    func setupViews() {
        
    }
    
    func addTapGestures() {
        viewsGesturesRelations().forEach { (view, action) in
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        }
    }
    
    func viewsGesturesRelations() -> [UIView: Selector] {
        return [:]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        didLayoutSuccessfully()
    }
    
    func didLayoutSuccessfully() {
        
    }
}
