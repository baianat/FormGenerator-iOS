//
//  DatePickerFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol DatePickerFieldDescriptorDelegate: class {
    func datePickerFieldDescriptor(
        _ descriptor: DatePickerFieldDescriptor,
        didSelectDate date: Date?
    )
}

public class DatePickerFieldDescriptor: Descriptor {
    public init(
        defaultValue: Date? = nil,
        maxDate: Date? = nil,
        minDate: Date? = nil,
        label: String? = nil,
        rules: [Rule] = [NotNilRule(errorMessage: ErrorMessages.youMustSelectDate)]
    ) {
        super.init(label: label, rules: rules)
        self.selectedValue = defaultValue
        self.maxDate = maxDate
        self.minDate = minDate
    }
    public weak var delegate: DatePickerFieldDescriptorDelegate?
    
    public var maxDate: Date?
    public var minDate: Date?
    
    public var selectedValue: Date?
    
    public override func createComponent() -> FormComponentProtocol {
        let textField = UIPickerViewTextField()
        return DatePickerComponent(descriptor: self, textField: textField)
    }
}
