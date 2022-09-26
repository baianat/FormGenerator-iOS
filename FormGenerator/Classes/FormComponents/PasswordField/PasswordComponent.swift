//
//  PasswordComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard
import PSMeter

public class PasswordComponent: BaseComponent<PasswordFieldDescriptor>, FormComponentProtocol {
    public var textField: UIPasswordTextField
    public var psMeter: PSMeter?
    
    private var validationCase: ValidationCase?
    
    private var confirmPasswordComponent: ConfirmPasswordComponent?
    
    public init(descriptor: PasswordFieldDescriptor, textField: UIPasswordTextField) {
        self.textField = textField
        self.textField.disableAutoFill()
        if descriptor.shouldShowConfirmField {
            confirmPasswordComponent = ConfirmPasswordComponent(
                descriptor: descriptor,
                originalTextField: textField
            )
        }
        super.init(descriptor: descriptor)
        
        self.textField.addTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
    
    @objc func textDidChangeAction() {
        descriptor.delegate?.passwordFieldDescriptor(descriptor, passwordTextField: textField, didChangeEditing: textField.text)
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let outerStackView = ViewUtils.createStackView(spacing: alignments.componentsSpacing)
        
        outerStackView.addArrangedSubview(buildView(alignments: alignments))
        
        //Confirm Field
        if descriptor.shouldShowConfirmField {
            outerStackView.addArrangedSubview(
                confirmPasswordComponent!.buildComponent(alignments: alignments)
            )
        }
        
        return outerStackView
    }
    
    private func buildView(alignments: FormAlignments) -> UIView {
        self.foundationView = textField
        let innerStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        //TitleLabel
        if let title = descriptor.label {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            innerStackView.addArrangedSubview(titleLabel!)
        }
        //Component
        if descriptor.decorator.showPlaceHolderImage! {
            textField.setupIcon(image: descriptor.decorator.placeHolderImage, iconWidth: descriptor.decorator.iconSize)
            textField.editingRectInsets = .init(top: 0, left: 40, bottom: 0, right: 40)
        } else {
            textField.editingRectInsets = .init(top: 0, left: 12, bottom: 0, right: 40)
        }
        
        innerStackView.addArrangedSubview(textField)
        
        //Error Label
        if descriptor.shouldUsePasswordMeter {
            psMeter = PSMeter()
            psMeter?.delegate = self
            innerStackView.addArrangedSubview(psMeter!)
            textField.addTarget(
                self,
                action: #selector(textFieldDidChangeEditingHandler),
                for: .editingChanged)
            
            psMeter?.statesDecorator = PStrengthViewStatesDecorator(
                emptyPasswordDecorator: .emptyDecorator,
                veryWeakPasswordDecorator: .veryWeakDecorator,
                weakPasswordDecorator: .weakDecorator,
                fairPasswordDecorator: .fairDecorator,
                strongPasswordDecorator: .strongDecorator,
                veryStrongPasswordDecorator: .veryStrongDecorator
            )
        }
        
        errorLabel = ViewUtils.createErrorLabel()
        innerStackView.addArrangedSubview(errorLabel!)
        
        return innerStackView
    }
    
    @objc func textFieldDidChangeEditingHandler() {
        psMeter?.updateStrengthIndication(password: textField.text ?? "")
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public override func applyStyle(style: FormStyle) {
        confirmPasswordComponent?.applyStyle(style: style)
        super.applyStyle(style: style)
        psMeter?.font = style.errorLabelFont
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        validationCase = vanguard.validate(textField: textField, byRules: descriptor.rules)
        confirmPasswordComponent?.registerValidation(inVanguard: vanguard)
    }
    
    public func updateSelectedValue() {
        if validationCase?.validate() == .valid && confirmPasswordComponent?.isValid() != false {
            descriptor.selectedValue = textField.text
        } else {
            descriptor.selectedValue = nil
        }
        
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValue = nil
    }
    
    public func applyDefaultValues() {
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        let hasOriginal = hasOriginalField(vanguardComponent: vanguardComponent)
        if descriptor.shouldShowConfirmField {
            return hasOriginal ||
                confirmPasswordComponent!.hasComponent(vanguardComponent: vanguardComponent)
        }
        return hasOriginal
    }
    
    private func hasOriginalField(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? UITextField else {
            return false
        }
        return component === textField
    }
    
    public override func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        confirmPasswordComponent?.setErrorState(errorMessage: errorMessage, shouldHideErrorLabel: shouldHideErrorLabel)
        
        guard case .invalid = validationCase?.validate() else {
            return
        }
        if descriptor.shouldUsePasswordMeter {
            if psMeter?.passwordStrength == .empty {
                super.setErrorState(errorMessage: errorMessage, shouldHideErrorLabel: shouldHideErrorLabel)
            } else {
                textField.setStrokeColor(color: style.failureColor, width: style.textFieldBorderWidth)
            }
        } else {
            super.setErrorState(errorMessage: errorMessage, shouldHideErrorLabel: shouldHideErrorLabel)
        }
    }
    
    public override func removeErrorState() {
        confirmPasswordComponent?.removeErrorState()
        
        guard case .valid = validationCase?.validate() else {
            return
        }
        super.removeErrorState()
    }
    
    public override func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        confirmPasswordComponent?.applyEditingChangeStyle(using: editingStylizer)
        super.applyEditingChangeStyle(using: editingStylizer)
    }
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    deinit {
        textField.removeTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
}

extension PasswordComponent: PSMeterDelegate {
    public func psMeter(_ psMeter: PSMeter, didChangeStrength passwordStrength: PasswordStrength) {
        errorLabel?.isHidden = passwordStrength != .empty
        self.psMeter?.isHidden = passwordStrength == .empty
    }
}

extension StateDecorator {
    static let emptyDecorator = StateDecorator(
        text: "",
        textColor: .clear,
        progressColor: .clear
    )
    
    static let veryWeakDecorator = StateDecorator(
        text: Localize.veryWeak(),
        textColor: .red,
        progressColor: .red
    )
    
    static let weakDecorator = StateDecorator(
        text: Localize.weak(),
        textColor: .red,
        progressColor: .red
    )
    
    static let fairDecorator = StateDecorator(
        text: Localize.fair(),
        textColor: .orange,
        progressColor: .orange
    )
    
    static let strongDecorator = StateDecorator(
        text: Localize.strong(),
        textColor: .green,
        progressColor: .green
    )
    
    static let veryStrongDecorator = StateDecorator(
        text: Localize.veryStrong(),
        textColor: .green,
        progressColor: .green
    )
}
