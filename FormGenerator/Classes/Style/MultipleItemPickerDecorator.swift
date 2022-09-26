//
//  ItemPickerDecorator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 04/04/2021.
//

import UIKit

public enum FormBorderStyle {
    case stroke(lineWidth: CGFloat = 1)
    case dash(lineWidth: CGFloat = 1, dashSize: NSNumber = 3, gapSize: NSNumber = 3)
}

public struct MultipleItemPickerDecorator {
    public init(
        uploadButtonIcon: UIImage? = iconUpload,
        uploadButtonSize: CGSize = CGSize(width: 40, height: 40),
        addButtonIcon: UIImage? = iconPlusFilled,
        addButtonSize: CGSize = CGSize(width: 24, height: 24),
        borderStyle: FormBorderStyle = .stroke(),
        cornerRadius: CGFloat = FormDefaultAspects.textfieldCornerRadius,
        emptyCollectionHeight: CGFloat? = nil,
        expandedCollectionHeight: CGFloat = 200
    ) {
        self.uploadButtonIcon = uploadButtonIcon
        self.uploadButtonSize = uploadButtonSize
        self.addButtonIcon = addButtonIcon
        self.addButtonSize = addButtonSize
        self.borderStyle = borderStyle
        self.cornerRadius = cornerRadius
        self.expandedCollectionHeight = expandedCollectionHeight
        self.emptyCollectionHeight = emptyCollectionHeight
    }
    
    public var uploadButtonIcon: UIImage? = R.image.iconUpload()
    public var uploadButtonSize: CGSize = CGSize(width: 40, height: 40)
    public var addButtonIcon: UIImage? = R.image.iconPlusFilled()
    public var addButtonSize: CGSize = CGSize(width: 24, height: 24)
    public var borderStyle: FormBorderStyle = .stroke()
    public var cornerRadius: CGFloat = FormDefaultAspects.textfieldCornerRadius
    public var expandedCollectionHeight: CGFloat = 200
    public var emptyCollectionHeight: CGFloat?
    
}

extension MultipleItemPickerDecorator {
    public static let iconUpload = R.image.iconUpload()
    public static let iconPlusFilled = R.image.iconPlusFilled()
}
