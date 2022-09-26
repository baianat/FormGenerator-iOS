//
//  MultipleFieldsDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol MultipleFieldsDescriptorDelegate: class {
    func multipleFieldsDescriptor(
        _ descriptor: MultipleFieldsDescriptor,
        didAddNewField textField: UITextField
    )
    
    func multipleFieldsDescriptor(
        _ descriptor: MultipleFieldsDescriptor,
        didChangeSelectedValues values: [String]
    )
    
    func multipleFieldsDescriptorDidRemoveField(
        _ descriptor: MultipleFieldsDescriptor
    )
}

public extension MultipleFieldsDescriptorDelegate {
    func multipleFieldsDescriptor(
        _ descriptor: MultipleFieldsDescriptor,
        didAddNewField textField: UITextField
    ) {}
    
    func multipleFieldsDescriptorDidRemoveField(
        _ descriptor: MultipleFieldsDescriptor
    ) {}
}

public class MultipleFieldsDescriptor: Descriptor {
    public init(
        minNumberOfItems: Int = 1,
        maxNumberOfItems: Int = .max,
        label: String? = nil,
        fieldPlaceholder: String? = nil,
        rules: [Rule] = []
    ) {
        self.minNumberOfItems = minNumberOfItems
        self.maxNumberOfItems = maxNumberOfItems
        self.fieldPlaceholder = fieldPlaceholder
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: MultipleFieldsDescriptorDelegate?
    
    public var minNumberOfItems: Int
    public var maxNumberOfItems: Int
    
    public var fieldPlaceholder: String?
    
    public var selectedValues: [String] = []
    
    public override func createComponent() -> FormComponentProtocol {
        return MultipleFieldsComponent(descriptor: self)
    }
}
