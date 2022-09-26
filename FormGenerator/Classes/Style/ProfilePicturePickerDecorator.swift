//
//  ProfilePicturePickerDecorator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 11/04/2021.
//

import UIKit

public enum FrameStyle {
    case circle
    case square(cornerRadius: CGFloat = 16)
}

public struct ProfilePicturePickerDecorator {
    public init(
        showPickButton: Bool = true,
        pickButtonColor: UIColor = .green,
        pickButtonSize: CGFloat = 32,
        pickButtonIcon: UIImage? = pickIcon,
        placeholderImage: UIImage? = placeholder,
        imageViewSize: CGFloat = 88,
        frameStyle: FrameStyle = .circle,
        titleColor: UIColor? = nil
    ) {
        self.showPickButton = showPickButton
        self.pickButtonColor = pickButtonColor
        self.pickButtonSize = pickButtonSize
        self.pickButtonIcon = pickButtonIcon
        self.placeholderImage = placeholderImage
        self.imageViewSize = imageViewSize
        self.frameStyle = frameStyle
        self.titleColor = titleColor
    }
    
    public var showPickButton: Bool
    public var pickButtonColor: UIColor
    public var pickButtonSize: CGFloat
    public var pickButtonIcon: UIImage?
    public var placeholderImage: UIImage?
    public var imageViewSize: CGFloat
    public var frameStyle: FrameStyle
    public var titleColor: UIColor?
}

public extension ProfilePicturePickerDecorator {
    static let pickIcon = R.image.iconEdit()
    static let placeholder = R.image.profilePlaceholder()
}
