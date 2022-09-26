//
//  FormStyle.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 23/03/2021.
//

import UIKit

public class FormStyle {
    public init(
        textFieldFont: UIFont = UIFont.systemFont(ofSize: 16),
        titleLabelFont: UIFont = UIFont.systemFont(ofSize: 16),
        errorLabelFont: UIFont = UIFont.systemFont(ofSize: 13),
        titleLabelSidePadding: CGFloat = 0,
        inactiveBorderColor: UIColor = .gray,
        activeBorderColor: UIColor = .black,
        textColor: UIColor = .black,
        failureColor: UIColor = .red,
        textFieldCornerRadius: CGFloat = FormDefaultAspects.textfieldCornerRadius,
        textFieldBorderWidth: CGFloat = FormDefaultAspects.textfieldBorderWidth,
        textFieldHeight: CGFloat = FormDefaultAspects.textFieldHeight
    ) {
        self.textFieldFont = textFieldFont
        self.titleLabelFont = titleLabelFont
        self.errorLabelFont = errorLabelFont
        self.inactiveBorderColor = inactiveBorderColor
        self.activeBorderColor = activeBorderColor
        self.textColor = textColor
        self.failureColor = failureColor
        self.textFieldCornerRadius = textFieldCornerRadius
        self.textFieldBorderWidth = textFieldBorderWidth
        self.textFieldHeight = textFieldHeight
        self.titleLabelSidePadding = titleLabelSidePadding
    }
    
    public var textFieldFont: UIFont
    public var titleLabelFont: UIFont
    public var errorLabelFont: UIFont
    
    public var titleLabelSidePadding: CGFloat
    
    public var inactiveBorderColor: UIColor
    public var activeBorderColor: UIColor
    public var textColor: UIColor
    public var failureColor: UIColor
    
    public var textFieldCornerRadius: CGFloat
    public var textFieldBorderWidth: CGFloat
    public var textFieldHeight: CGFloat
}
