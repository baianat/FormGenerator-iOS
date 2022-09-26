//
//  NameComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard

public class NameComponent: BaseComponent<NameFieldDescriptor>, FormComponentProtocol {
    public var textField: OutlinedTextField
    var validationCase: ValidationCase?
    
    public init(descriptor: NameFieldDescriptor, textField: OutlinedTextField) {
        self.textField = textField
        self.textField.keyboardType = .namePhonePad
        self.textField.textContentType = .name
        
        super.init(descriptor: descriptor)
        
        self.textField.addTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
    
    @objc func textDidChangeAction() {
        descriptor.delegate?.nameFieldDescriptor(descriptor, textDidChange: textField.text)
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        if descriptor.decorator.showPlaceHolderImage! {
            textField.setupIcon(image: descriptor.decorator.placeHolderImage, iconWidth: descriptor.decorator.iconSize)
            textField.editingRectInsets = .init(top: 0, left: 40, bottom: 0, right: 35)
        }
        return buildComponentView(foundationView: textField, innerSpacing: alignments.componentInnerSpacing)
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        validationCase = vanguard.validate(textField: textField, byRules: descriptor.rules)
    }
    
    public func updateSelectedValue() {
        descriptor.selectedValue = textField.text
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValue = nil
    }
    
    public func applyDefaultValues() {
        textField.text = descriptor.selectedValue
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? UITextField else {
            return false
        }
        return component === textField
    }
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    deinit {
        textField.removeTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
}
