//
//  NumbersComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard

public class NumbersComponent: BaseComponent<NumbersFieldDescriptor>, FormComponentProtocol {
    public var textField: UITextField
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: NumbersFieldDescriptor, textField: UITextField) {
        self.textField = textField
        self.textField.keyboardType = .numberPad
        super.init(descriptor: descriptor)
        
        self.textField.addTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
    
    @objc func textDidChangeAction() {
        descriptor.delegate?.numbersFieldDescriptor(descriptor, textDidChange: Double(textField.text ?? ""))
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        return buildComponentView(foundationView: textField, innerSpacing: alignments.componentInnerSpacing)
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        validationCase = vanguard.validate(textField: textField, byRules: descriptor.rules)
    }
    
    public func updateSelectedValue() {
        descriptor.selectedValue = Double(textField.text ?? "")
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValue = nil
    }
    
    public func applyDefaultValues() {
        textField.text = descriptor.selectedValue?.toString()
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? UITextField else {
            return false
        }
        return component === textField
    }
    
    deinit {
        textField.removeTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
}

extension Double {
    func toString() -> String {
        return String(self)
    }
}
