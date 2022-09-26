//
//  PasswordFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol PasswordFieldDescriptorDelegate: class {
    func passwordFieldDescriptor(
        _ descriptor: PasswordFieldDescriptor,
        passwordTextField: UIPasswordTextField,
        didChangeEditing newText: String?
    )
    
    func passwordFieldDescriptor(
        _ descriptor: PasswordFieldDescriptor,
        confirmPasswordTextField: UIPasswordTextField,
        didChangeEditing newText: String?
    )
}

public extension PasswordFieldDescriptorDelegate {
    func passwordFieldDescriptor(
        _ descriptor: PasswordFieldDescriptor,
        confirmPasswordTextField: UIPasswordTextField,
        didChangeEditing newText: String?
    ) {
        
    }
}

public class PasswordFieldDescriptor: Descriptor {
    public init(
        shouldShowConfirmField: Bool = false,
        shouldUsePasswordMeter: Bool = true,
        label: String? = nil,
        confirmLabel: String? = nil,
        rules: [Rule] = [PasswordNotWeakRule(errorMessage: ErrorMessages.pleaseEnterStrongPassword)],
        decorator: TextFieldDecorator = TextFieldDecorator()
    ) {
        self.shouldShowConfirmField = shouldShowConfirmField
        self.shouldUsePasswordMeter = shouldUsePasswordMeter
        self.confirmLabel = confirmLabel
        self.decorator = decorator
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: PasswordFieldDescriptorDelegate?
    
    var shouldShowConfirmField: Bool
    var shouldUsePasswordMeter: Bool
    
    public var confirmPasswordError: String?
    public var confirmLabel: String?
    
    public var selectedValue: String?
    public var decorator: TextFieldDecorator
    
    public override func createComponent() -> FormComponentProtocol {
        let textField = UIPasswordTextField()
        return PasswordComponent(descriptor: self, textField: textField)
    }
}
