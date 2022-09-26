//
//  PhoneFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import FlagPhoneNumber
import Vanguard

public protocol PhoneFieldDescriptorDelegate: class {
    func phoneFieldDescriptor(
        _ descriptor: PhoneFieldDescriptor,
        textDidChange newText: String?,
        selectedCountryCode: String
    )
}

public class PhoneFieldDescriptor: Descriptor {
    public init(
        defaultCountryCode: String? = nil,
        label: String? = nil,
        rules: [Rule] = [FPNPhoneNumberRule(errorMessage: ErrorMessages.phoneNumberIsNotValid)]
    ) {
        self.defaultCountryCode = defaultCountryCode
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: PhoneFieldDescriptorDelegate?
    
    public var defaultCountryCode: String?
    public var selectedValue: PhoneNumber?
    
    
    public override func createComponent() -> FormComponentProtocol {
        let textField = FPNTextField()
        return PhoneComponent(descriptor: self, textField: textField)
    }
}
