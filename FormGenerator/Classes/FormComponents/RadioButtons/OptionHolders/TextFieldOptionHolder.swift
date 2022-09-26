//
//  TextFieldOptionHolder.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 14/09/2021.
//

import UIKit
import M13Checkbox

protocol TextFieldOptionHolderDelegate: AnyObject {
    func textFieldOptionHolder(
        _ holder: TextFieldOptionHolder,
        textFieldDidChangeEditing textField: OutlinedTextField
    )
}

class TextFieldOptionHolder: OptionHolder {
    
    let checkBoxView: M13Checkbox
    let textField: OutlinedTextField
    let contract: TextFieldContract
    let decorator: RadioOptionTextFieldDecorator
    weak var textFieldDelegate: TextFieldOptionHolderDelegate?
    
    init(
        checkBox: M13Checkbox,
        textField: OutlinedTextField,
        contract: TextFieldContract,
        decorator: RadioOptionTextFieldDecorator,
        textFieldDelegate: TextFieldOptionHolderDelegate?
    ) {
        self.checkBoxView = checkBox
        self.textField = textField
        self.contract = contract
        self.decorator = decorator
        self.textFieldDelegate = textFieldDelegate
        
        self.applyDecorator()
        self.applyContract()
        self.setup()
    }
    
    private func applyDecorator() {
        textField.font = decorator.font
        textField.textColor = decorator.textColor
    }
    
    private func applyContract() {
        textField.keyboardType = contract.keyboardType
    }
    
    private func setup() {
        textField.addTarget(
            self,
            action: #selector(editingChangedHandler),
            for: .editingChanged
        )
    }
    
    @objc func editingChangedHandler() {
        textFieldDelegate?.textFieldOptionHolder(
            self,
            textFieldDidChangeEditing: textField
        )
    }
    
    var checkBox: M13Checkbox {
        return checkBoxView
    }
    
    var isChecked: Bool {
        get {
            return checkBox.checkState == .checked
        }
        
        set {
            if newValue {
                checkBox.checkState = .checked
            } else {
                checkBox.checkState = .unchecked
                textField.endEditing(true)
                textField.text = nil
            }
            textField.isEnabled = newValue
        }
    }
    
    var supplementaryView: UIView {
        return textField
    }
    
    weak var delegate: OptionHolderDelegate?
    
    func setCheckActionOnSupplementaryView() {
        textField.addTarget(self, action: #selector(beginEditingHandler), for: .editingDidBegin)
    }
    
    @objc func beginEditingHandler() {
        delegate?.optionHolderDidTapOnSupplementaryView(view: textField)
    }
    
    func getValue(index: Int) -> RadioButtonValue? {
        let text = textField.text ?? ""
        let textIsValid = contract.rules.allSatisfy({ rule in
            rule.validate(validatable: text)
        })
        guard textIsValid else {
            return nil
        }
        return .selectionWithTextValue(index: index, value: text)
    }
    
    func applyStyle(style: FormStyle) {
        textField.setCornerRadius(value: style.textFieldCornerRadius)
        textField.setHeightEqualToConstant(style.textFieldHeight)
        textField.setStrokeColor(color: style.inactiveBorderColor, width: style.textFieldBorderWidth)
    }
}
