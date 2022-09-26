//
//  NameFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol NameFieldDescriptorDelegate: AnyObject {
    func nameFieldDescriptor(
        _ descriptor: NameFieldDescriptor,
        textDidChange newText: String?
    )
}

public class NameFieldDescriptor: Descriptor {
    public init(
        label: String? = nil,
        maxLength: Int = 36,
        rules: [Rule] = [
            NotEmptyRule(errorMessage: ErrorMessages.nameMustNotBeEmpty),
            MinCharLengthRule(
                min: 2,
                errorMessage: ErrorMessages.nameMustNotBeLessThan2Characters
            ).notRequiredIfEmpty(),
            ContainsSpecialCharactersRule(
                errorMessage: ErrorMessages.nameMustNotContainSpecialCharacters
            ).reversed().notRequiredIfEmpty()
        ],
        decorator: TextFieldDecorator = TextFieldDecorator()
    ) {
        self.decorator = decorator
        self.maxLength = maxLength
        super.init(label: label, rules: rules)
    }
    
    private let maxLength: Int
    
    public weak var delegate: NameFieldDescriptorDelegate?
    
    public var selectedValue: String?
    public var decorator: TextFieldDecorator
    
    public override func createComponent() -> FormComponentProtocol {
        let textField = OutlinedTextField()
        textField.maxLength = maxLength
        return NameComponent(descriptor: self, textField: textField)
    }
}
