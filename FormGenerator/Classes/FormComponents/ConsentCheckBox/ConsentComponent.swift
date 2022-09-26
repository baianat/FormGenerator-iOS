//
//  ConsentComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard

public class ConsentComponent: FormComponentProtocol {
    public let descriptor: ConsentCheckBoxDescriptor
    public var consentView: ConsentView
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(
        descriptor: ConsentCheckBoxDescriptor,
        consentView: ConsentView = ConsentView()
    ) {
        self.descriptor = descriptor
        self.consentView = consentView
        self.consentView.setup(decorator: descriptor.decorator)
        self.consentView.delegate = self
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        return consentView
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        validationCase = DefaultValidationCase(
            component: consentView.vanguardComponent(),
            rules: descriptor.rules
        )
        vanguard.addValidationCases(validationCase!)
    }
    
    public func updateSelectedValue() {
        descriptor.selectedValue = consentView.isChecked
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValue = false
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? ConsentView else {
            return false
        }
        return component === consentView
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        consentView.shake()
    }
    
    public func removeErrorState() {
    }
    
    public func getComponentOrigin() -> CGPoint {
        return consentView.getOriginRelativeToSupremeView()
    }
    
    public func applyDefaultValues() {
        consentView.isChecked = descriptor.selectedValue
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
    }
    
    public func applyStyle(style: FormStyle) {
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
    }
}

extension ConsentComponent: ConsentViewDelegate {
    public func didTapOnLink(link: URL) {
        guard descriptor.delegate?.consentCheckBoxDescriptor(
                descriptor,
                shouldOpenUrl: link
        ) != false else {
            return
        }
        UIApplication.shared.open(link, options: [:], completionHandler: nil)
    }
    
}
