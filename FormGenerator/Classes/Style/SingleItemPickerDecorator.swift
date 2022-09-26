//
//  SingleItemPickerDecorator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 04/04/2021.
//

import UIKit

public struct SingleItemPickerDecorator {
    public init(
        uploadButtonIcon: UIImage? = iconUpload,
        uploadButtonSize: CGSize = CGSize(width: 40, height: 40),
        docFileIcon: UIImage? = iconPdf,
        docFileIconHeight: CGFloat = 72,
        borderStyle: FormBorderStyle = .stroke(),
        cornerRadius: CGFloat = FormDefaultAspects.textfieldCornerRadius,
        maxHeightWhenFilled: CGFloat = 200,
        heightToWidthRatioWhenFilled: CGFloat = 1/2
    ) {
        self.uploadButtonIcon = uploadButtonIcon
        self.uploadButtonSize = uploadButtonSize
        self.docFileIcon = docFileIcon
        self.docFileIconHeight = docFileIconHeight
        self.borderStyle = borderStyle
        self.cornerRadius = cornerRadius
        self.maxHeightWhenFilled = maxHeightWhenFilled
        self.heightToWidthRatioWhenFilled = heightToWidthRatioWhenFilled
    }
    
    public var uploadButtonIcon: UIImage? = R.image.iconUpload()
    public var uploadButtonSize: CGSize = CGSize(width: 40, height: 40)
    public var docFileIcon: UIImage? = R.image.iconPdf()
    public var docFileIconHeight: CGFloat = 72
    public var borderStyle: FormBorderStyle = .stroke()
    public var cornerRadius: CGFloat = FormDefaultAspects.textfieldCornerRadius
    public var maxHeightWhenFilled: CGFloat = 200
    public var heightToWidthRatioWhenFilled: CGFloat = 1/2
    
}

extension SingleItemPickerDecorator {
    public static let iconUpload = R.image.iconUpload()
    public static let iconPdf = R.image.iconPdf()
}
