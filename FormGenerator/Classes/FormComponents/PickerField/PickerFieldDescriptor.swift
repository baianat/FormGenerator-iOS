//
//  PickerFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol PickerFieldDescriptorDelegate: AnyObject {
    func pickerFieldDescriptor(
        _ descriptor: PickerFieldDescriptor,
        didSelectItemAt selectedIndex: Int?,
        selectedValue: String?)
}

public class PickerFieldDescriptor: Descriptor {
    public static func createWithAlertPicker(
        alertTitle: String? = nil,
        label: String? = nil,
        rules: [Rule] = [NotNilRule(errorMessage: ErrorMessages.youMustSelectValue)]
    ) -> PickerFieldDescriptor {
        let descriptor = PickerFieldDescriptor(label: label, rules: rules)
        descriptor.pickerType = .alert
        descriptor.alertTitle = alertTitle
        return descriptor
    }
    
    public static func createWithPickerView(
        label: String? = nil,
        rules: [Rule] = [NotNilRule(errorMessage: ErrorMessages.youMustSelectValue)]
    ) -> PickerFieldDescriptor {
        let descriptor = PickerFieldDescriptor(label: label, rules: rules)
        descriptor.pickerType = .pickerView
        return descriptor
    }
    
    var alertTitle: String?
    var pickerType: PickerType = .alert
    
    public weak var delegate: PickerFieldDescriptorDelegate?
    
    public var selectedValue: String?
    public var selectedIndex: Int?
    
    public var values: [String] = []
    
    public override func createComponent() -> FormComponentProtocol {
        let textField = UIPickerViewTextField()
        textField.pickerType = pickerType
        switch pickerType {
        case .alert:
            return PickerAlertComponent(descriptor: self, textField: textField)
            
        case .pickerView:
            return PickerViewComponent (descriptor: self, textField: textField)
        }
        
    }
}
