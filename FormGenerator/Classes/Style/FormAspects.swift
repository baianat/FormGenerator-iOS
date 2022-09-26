//
//  Aspects.swift
//  InstacareUtils
//
//  Created by Omar on 10/5/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

public struct FormDefaultAspects {
    static public let textfieldBorderWidth: CGFloat = 1
    static public let textFieldHeight: CGFloat = isiPad() ? 54 : 48.0
    static public let textFieldLeadingPadding: CGFloat = 12.0
}

// MARK: Corner Radii
public extension FormDefaultAspects {
    static let textfieldCornerRadius: CGFloat = 8
}

// MARK: Font sizes
public extension FormDefaultAspects {
    static let textfieldTitleLabelTextSize: CGFloat = 16.0
}

// MARK: Buttons
public extension FormDefaultAspects {
    static let buttonHeight: CGFloat = isiPad() ? 54 : 48.0
}
