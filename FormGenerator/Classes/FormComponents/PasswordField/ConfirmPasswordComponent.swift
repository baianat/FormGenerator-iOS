//
//  ConfirmPasswordComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 28/03/2021.
//

import UIKit
import Vanguard

public class ConfirmPasswordComponent: FormComponentProtocol {
    public var confirmTextField: UIPasswordTextField
    public weak var originalTextField: UIPasswordTextField!
    public let descriptor: PasswordFieldDescriptor
    
    public var titleLabel: FormLabel?
    public var errorLabel: UILabel?
    
    private lazy var style = FormStyle()
    private var validationCase: ValidationCase?
    
    public init(descriptor: PasswordFieldDescriptor, originalTextField: UIPasswordTextField) {
        self.originalTextField = originalTextField
        self.confirmTextField = UIPasswordTextField()
        self.confirmTextField.disableAutoFill()
        self.descriptor = descriptor
        
        self.confirmTextField.addTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
    
    @objc func textDidChangeAction() {
        descriptor.delegate?.passwordFieldDescriptor(descriptor, confirmPasswordTextField: confirmTextField, didChangeEditing: confirmTextField.text)
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let innerStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        //TitleLabel
        if let title = getComponentLabel() {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            innerStackView.addArrangedSubview(titleLabel!)
        }
        
        //Component
        innerStackView.addArrangedSubview(confirmTextField)
        
        //ErrorLabel
        errorLabel = ViewUtils.createErrorLabel()
        innerStackView.addArrangedSubview(errorLabel!)
        
        return innerStackView
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.confirmLabel
    }
    
    public func updateSelectedValue() {
        //left intentionally
    }
    
    public func removeSelectedValue() {
        //left intentionally
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        let confirmError = descriptor.confirmPasswordError ?? Localize.bothPasswordsMustBeTheSame()
        
        validationCase = vanguard.validate(
            textField: confirmTextField,
            byRules: [
                PasswordMatchRule(
                    textField: originalTextField!,
                    errorMessage: confirmError
                )
            ]
        )
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? UIPasswordTextField else {
            return false
        }
        return component === confirmTextField
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        guard case .invalid = validationCase?.validate() else {
            return
        }
        
        errorLabel?.isHidden = shouldHideErrorLabel || (errorMessage == nil)
        errorLabel?.text = errorMessage
        
        confirmTextField.setStrokeColor(color: style.failureColor, width: style.textFieldBorderWidth)
    }
    
    public func removeErrorState() {
        guard case .valid = validationCase?.validate() else {
            return
        }
        
        errorLabel?.isHidden = true
        errorLabel?.text = nil
        
        setValidBorderColor()
    }
    
    public func getComponentOrigin() -> CGPoint {
        return titleLabel?.getOriginRelativeToSupremeView() ?? .zero
    }
    
    private func setValidBorderColor() {
        let borderColor: UIColor = confirmTextField.isFirstResponder == true ? style.activeBorderColor : style.inactiveBorderColor
        confirmTextField.setStrokeColor(color: borderColor, width: style.textFieldBorderWidth)
    }
    
    public func applyStyle(style: FormStyle) {
        self.style = style
        titleLabel?.font = style.titleLabelFont
        titleLabel?.textColor = style.textColor
        titleLabel?.insets = UIEdgeInsets(
            top: 0,
            left: style.titleLabelSidePadding,
            bottom: 0,
            right: style.titleLabelSidePadding
        )
        
        errorLabel?.font = style.errorLabelFont
        errorLabel?.textColor = style.failureColor
        
        confirmTextField.font = style.textFieldFont
        confirmTextField.textColor = style.textColor
        
        confirmTextField.setCornerRadius(value: style.textFieldCornerRadius)
        confirmTextField.textFieldHeight = style.textFieldHeight
        
        setValidBorderColor()
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        editingStylizer.setupTextField(textField: confirmTextField)
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
        if configuration.showPlaceholders {
            confirmTextField.placeholder = getComponentLabel()
        }
    }
    
    public func applyDefaultValues() {
    }
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    deinit {
        confirmTextField.removeTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
}
