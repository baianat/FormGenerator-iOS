//
//  FieldWithPickerDecorator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 12/09/2021.
//

import UIKit

public struct FieldWithPickerDecorator {
    public init(
        pickerBackgroundColor: UIColor = .white,
        pickerTextColor: UIColor = .systemBlue,
        pickerTextFont: UIFont = .systemFont(ofSize: 14),
        pickerWidth: CGFloat = 100,
        fieldKeyboardType: UIKeyboardType = .default
    ) {
        self.pickerBackgroundColor = pickerBackgroundColor
        self.pickerTextColor = pickerTextColor
        self.pickerTextFont = pickerTextFont
        self.pickerWidth = pickerWidth
        self.fieldKeyboardType = fieldKeyboardType
    }
    
    public var pickerBackgroundColor: UIColor
    public var pickerTextColor: UIColor
    public var pickerTextFont: UIFont
    public var pickerWidth: CGFloat
    public var fieldKeyboardType: UIKeyboardType
}
