//
//  PrimaryAndSecondaryPickersDecorator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 12/04/2021.
//

import UIKit

public struct MultiplePickersDecorator {
    public init(
        addButtonColor: UIColor = .blue,
        addButtonTitleColor: UIColor = .white,
        addButtonTitle: String = addTitle,
        addButtonHeight: CGFloat = FormDefaultAspects.buttonHeight,
        addButtonFrameStyle: FrameStyle = .circle
    ) {
        self.addButtonColor = addButtonColor
        self.addButtonTitleColor = addButtonTitleColor
        self.addButtonTitle = addButtonTitle
        self.addButtonHeight = addButtonHeight
        self.addButtonFrameStyle = addButtonFrameStyle
    }
    
    public var addButtonColor: UIColor
    public var addButtonTitleColor: UIColor
    public var addButtonTitle: String
    public var addButtonHeight: CGFloat = FormDefaultAspects.buttonHeight
    public var addButtonFrameStyle: FrameStyle = .circle
}

public extension MultiplePickersDecorator {
    static let addTitle: String = Localize.add()
}
