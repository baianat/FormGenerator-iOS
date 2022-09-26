//
//  EmailFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol EmailFieldDescriptorDelegate: class {
    func emailFieldDescriptor(
        _ descriptor: EmailFieldDescriptor,
        textDidChange newText: String?
    )
}

public class EmailFieldDescriptor: Descriptor {
    
    public init(
        label: String? = nil,
        rules: [Rule] = [
            NotEmptyRule(errorMessage: ErrorMessages.fieldCantBeEmpty),
            EmailRule(errorMessage: ErrorMessages.emailIsNotValid).notRequiredIfEmpty()
        ],
        decorator: TextFieldDecorator = TextFieldDecorator()
    ) {
        self.decorator = decorator
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: EmailFieldDescriptorDelegate?
    
    public var selectedValue: String?
    public var decorator: TextFieldDecorator
    
    public override func createComponent() -> FormComponentProtocol {
        let textField = OutlinedTextField()
        return EmailComponent(descriptor: self, textField: textField)
    }
}
