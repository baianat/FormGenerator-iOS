//
//  PhoneNumber.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 28/03/2021.
//

import Foundation
import FlagPhoneNumber

public struct PhoneNumber {
    public init(countryCode: String, rawNumber: String) {
        self.countryCode = countryCode
        self.rawNumber = rawNumber
    }
    
    public init(fullNumber: String) {
        let textField = FPNTextField()
        textField.set(phoneNumber: fullNumber)
        let phoneModel = textField.phoneModel()
        self.init(
            countryCode: phoneModel.selectedCountry?.code ?? "",
            rawNumber: phoneModel.trimmedNumber ?? ""
        )
    }
    
    public let countryCode: String
    public let rawNumber: String
    
    public var fullPhoneNumber: String {
        return countryCode + rawNumber
    }
}

extension PhoneModel {
    func mapToFormPhoneNumber() -> PhoneNumber {
        return PhoneNumber(
            countryCode: selectedCountry?.code ?? "",
            rawNumber: trimmedNumber ?? ""
        )
    }
}
