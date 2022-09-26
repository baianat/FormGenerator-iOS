//
//  RadioButtonsDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol RadioButtonsDescriptorDelegate: AnyObject {
    func radioButtonsDescriptor(
        _ descriptor: RadioButtonsDescriptor,
        didChangeSelection selectedOptionIndex: Int?
    )
}

public enum FormAxis {
    case horizontal
    case vertical
}

public struct TextFieldContract {
    public init(rules: [Rule] = [NotEmptyRule()], keyboardType: UIKeyboardType = .default) {
        self.rules = rules
        self.keyboardType = keyboardType
    }
    
    public let rules: [Rule]
    public let keyboardType: UIKeyboardType
}

public enum RadioButtonOption {
    case normal(title: String)
    case withTextField(placeholder: String, contract: TextFieldContract)
}

public enum RadioButtonValue {
    case defaultSelection(index: Int)
    case selectionWithTextValue(index: Int, value: String)
    
    public func selectedIndex() -> Int {
        switch self {
            case .defaultSelection(let index):
                return index
            case .selectionWithTextValue(let index, _):
                return index
        }
    }
}

public class RadioButtonsDescriptor: Descriptor {
    public init(
        options: [RadioButtonOption] = [],
        axis: FormAxis = .vertical,
        decorator: RadioButtonDecorator = RadioButtonDecorator(),
        label: String? = nil,
        rules: [Rule] = [NotNilRule(errorMessage: ErrorMessages.youMustSelectValue)]
    ) {
        self.options = options
        self.axis = axis
        self.decorator = decorator
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: RadioButtonsDescriptorDelegate?
    
    public var options: [RadioButtonOption]
    public var axis: FormAxis
    public var decorator: RadioButtonDecorator
    
    public var selectedOption: RadioButtonValue?
    
    public override func createComponent() -> FormComponentProtocol {
        return RadioButtonsComponent(descriptor: self)
    }
}
