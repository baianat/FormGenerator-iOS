//
//  EmailFieldDecorator.swift
//  FormGenerator
//
//  Created by Abdelrahman on 20/06/2022.
//

import UIKit

public struct TextFieldDecorator {
    
    public let showPlaceHolderImage: Bool?
    public let placeHolderImage: UIImage?
    public let iconSize: CGFloat?
    
    public init(
        placeHolderImage: UIImage? = nil,
        showPlaceHolderImage: Bool? = false,
        iconSize: CGFloat? = 14
    ) {
        self.placeHolderImage = placeHolderImage
        self.showPlaceHolderImage = showPlaceHolderImage ?? false
        self.iconSize = iconSize
    }
}
