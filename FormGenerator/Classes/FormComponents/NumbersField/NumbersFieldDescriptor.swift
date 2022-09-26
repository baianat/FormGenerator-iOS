//
//  NumbersFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol NumbersFieldDescriptorDelegate: AnyObject {
    func numbersFieldDescriptor(
        _ descriptor: NumbersFieldDescriptor,
        textDidChange newNumber: Double?
    )
}

public class NumbersFieldDescriptor: Descriptor {
    public override init(
        label: String? = nil,
        rules: [Rule] = [NumericRule()]
    ) {
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: NumbersFieldDescriptorDelegate?
    
    public var selectedValue: Double?
    
    public override func createComponent() -> FormComponentProtocol {
        let textField = OutlinedTextField()
        textField.keyboardType = .numberPad
        return NumbersComponent(descriptor: self, textField: textField)
    }
}
