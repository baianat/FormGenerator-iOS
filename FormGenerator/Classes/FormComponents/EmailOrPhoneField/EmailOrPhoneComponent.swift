//
//  EmailOrPhoneComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard

//FIXME: EmailOrPhoneView
//public class EmailOrPhoneComponent: BaseComponent<EmailOrPhoneFieldDescriptor>, FormComponentProtocol {
//    public var textField: UITextField
//    
//    var validationCase: ValidationCase?
//    
//    public func isValid() -> Bool {
//        return validationCase?.validate() == .valid
//    }
//    
//    public init(descriptor: EmailOrPhoneFieldDescriptor, textField: UITextField) {
//        self.textField = textField
//        super.init(descriptor: descriptor)
//    }
//    
//    public func buildComponent(alignments: FormAlignments) -> UIView {
//        return buildComponentView(foundationView: textField, innerSpacing: alignments.componentInnerSpacing)
//    }
//    
//    public func getComponentLabel() -> String? {
//        return descriptor.label
//    }
//    
//    public func registerValidation(inVanguard vanguard: Vanguard) {
//        validationCase = vanguard.validate(textField: textField, byRules: descriptor.rules)
//    }
//    
//    public func updateSelectedValue() {
//        descriptor.selectedValue = textField.text
//    }
//    
//    public func removeSelectedValue() {
//        descriptor.selectedValue = nil
//    }
//    
//    public func applyDefaultValues() {
//        textField.text = descriptor.selectedValue
//    }
//    
//    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
//        guard let component = vanguardComponent.component as? UITextField else {
//            return false
//        }
//        return component === textField
//    }
//}
