//
//  FieldWithPickerDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 12/09/2021.
//

import Foundation
import Vanguard

public protocol FieldWithPickerDescriptorDelegate: AnyObject {
    func fieldWithPickerDescriptor(
        _ descriptor: FieldWithPickerDescriptor,
        didSelectItemAt selectedIndex: Int?
    )
}

public class FieldWithPickerDescriptor: Descriptor {
    
    public init(
        decorator: FieldWithPickerDecorator = .init(),
        label: String? = nil,
        pickerAlertTitle: String? = nil,
        fieldRules: [Rule] = [
            NotEmptyRule(errorMessage: "Field can't be empty")
        ],
        pickerRules: [Rule] = [
            NotNilRule(errorMessage: ErrorMessages.youMustSelectValue)
        ]
    ) {
        self.pickerRules = pickerRules
        self.decorator = decorator
        self.pickerAlertTitle = pickerAlertTitle
        super.init(label: label, rules: fieldRules)
    }
    var pickerRules: [Rule]
    
    public var decorator: FieldWithPickerDecorator
    public weak var delegate: FieldWithPickerDescriptorDelegate?
    public var pickerAlertTitle: String?
    
    public var fieldSelectedValue: String?
    public var pickerSelectedIndex: Int?
    
    public var pickerValues: [String] = []
    public var pickerErrorMessage: String?
    
    public override func createComponent() -> FormComponentProtocol {
        return FieldWithPickerComponent(
            textField: OutlinedTextField(),
            descriptor: self
        )
    }
}

