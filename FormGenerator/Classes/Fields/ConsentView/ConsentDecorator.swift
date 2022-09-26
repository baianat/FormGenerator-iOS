//
//  ConsentDecorator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit

public struct ConsentDecorator {
    public init(
        textSlices: [TextSlice],
        textColor: UIColor = .black,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        checkBoxFillColor: UIColor = .blue,
        checkBoxCheckColor: UIColor = .white
    ) {
        self.textColor = textColor
        self.font = font
        self.checkBoxFillColor = checkBoxFillColor
        self.checkBoxCheckColor = checkBoxCheckColor
        self.textSlices = textSlices
    }
    
    public let textColor: UIColor
    public let font: UIFont
    public let checkBoxFillColor: UIColor
    public let checkBoxCheckColor: UIColor
    public let textSlices: [TextSlice]
}
