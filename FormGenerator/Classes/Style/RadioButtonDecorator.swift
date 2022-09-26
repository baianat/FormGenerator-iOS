//
//  RadioButtonDecorator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 14/04/2021.
//

import UIKit

public struct RadioButtonDecorator {
    public init(
        fillColor: UIColor = .blue,
        checkColor: UIColor = .white,
        labelDecorator: RadioOptionLabelDecorator = RadioOptionLabelDecorator(),
        textFieldDecorator: RadioOptionTextFieldDecorator = RadioOptionTextFieldDecorator()
    ) {
        self.fillColor = fillColor
        self.checkColor = checkColor
        self.labelDecorator = labelDecorator
        self.textFieldDecorator = textFieldDecorator
    }
    
    public var fillColor: UIColor
    public var checkColor: UIColor
    public var labelDecorator: RadioOptionLabelDecorator
    public var textFieldDecorator: RadioOptionTextFieldDecorator
}

public struct RadioOptionLabelDecorator {
    public init(
        font: UIFont = .systemFont(ofSize: 14),
        textColor: UIColor = .black
    ) {
        self.font = font
        self.textColor = textColor
    }
    
    public let font: UIFont
    public let textColor: UIColor
}

public struct RadioOptionTextFieldDecorator {
    public init(
        font: UIFont = .systemFont(ofSize: 14),
        textColor: UIColor = .black
    ) {
        self.font = font
        self.textColor = textColor
    }
    
    public let font: UIFont
    public let textColor: UIColor
}
