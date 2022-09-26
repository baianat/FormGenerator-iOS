//
//  PhoneComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import FlagPhoneNumber
import Vanguard

public class PhoneComponent: BaseComponent<PhoneFieldDescriptor>, FormComponentProtocol {
    public var textField: FPNTextField
    var countryHelper: CountryPickerHelpers?
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: PhoneFieldDescriptor, textField: FPNTextField) {
        self.textField = textField
        self.textField.keyboardType = .phonePad
        self.textField.textContentType = .telephoneNumber
        
        super.init(descriptor: descriptor)
        
        self.textField.addTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
    
    @objc func textDidChangeAction() {
        descriptor.delegate?.phoneFieldDescriptor(
            descriptor,
            textDidChange: textField.text,
            selectedCountryCode: textField.selectedCountry?.code.rawValue ?? ""
        )
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let view = buildComponentView(foundationView: textField, innerSpacing: alignments.componentInnerSpacing)
        setupPhoneField()
        return view
    }
    
    private func setupPhoneField() {
        textField.heightAnchor.constraint(equalToConstant: style.textFieldHeight).isActive = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        
        let windows = UIApplication.shared.windows
        let currentWindow = windows.first(where: { (window) -> Bool in
            window.isKeyWindow
        }) ?? windows.first
        if let viewController = currentWindow?.rootViewController {
            countryHelper = CountryPickerHelpers.create(textField: textField, in: viewController, defaultCountryCode: descriptor.defaultCountryCode)
            countryHelper?.fire()
        }
        textField.keyboardType = .phonePad
        textField.textContentType = .telephoneNumber
        textField.setCornerRadius(value: style.textFieldCornerRadius)
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public override func applyConfiguration(configuration: FormConfiguration) {
        super.applyConfiguration(
            configuration: FormConfiguration(
                showPlaceholders: false
            )
        )
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        validationCase = DefaultValidationCase(
            component: textField.phoneVanguardComponent(),
            rules: descriptor.rules
        )
        vanguard.addValidationCases(validationCase!)
    }
    
    public func updateSelectedValue() {
        descriptor.selectedValue = textField.phoneModel().mapToFormPhoneNumber()
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValue = nil
    }
    
    public func applyDefaultValues() {
        textField.set(phoneNumber: descriptor.selectedValue?.fullPhoneNumber ?? "")
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? FPNTextField else {
            return false
        }
        return component === textField
    }
    
    deinit {
        textField.removeTarget(self, action: #selector(textDidChangeAction), for: .editingChanged)
    }
}
