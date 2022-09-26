//
//  PhoneModel.swift
//  Rigow
//
//  Created by Omar on 4/7/20.
//  Copyright © 2020 Omar. All rights reserved.
//

import UIKit
import FlagPhoneNumber

public struct PhoneModel: Equatable {
   
    /// +201016939292
    public var internationalNumber:String?
    
    /// +20 101 693 9292
    public var prettyNumber:String?
    
    /// 1016939292
    public var trimmedNumber:String?
    
    /// just as entered by user
    public var rawNumber:String?
    
    public var selectedCountry:Country?
    
    public func isEmpty() -> Bool {
        return trimmedNumber == "" || trimmedNumber == nil
    }
    public func hasPhoneNumber() -> Bool {
        return internationalNumber != selectedCountry?.code
    }
    
    public static func create(from phone:String) -> PhoneModel {
        return PhoneModel(internationalNumber: phone.internationalPhoneNumber(), prettyNumber: phone.prettyPhoneNumber(), rawNumber: phone.rawPhoneNumber())
    }
    
    public func isValidPhone() -> Bool {
        let phoneNumberUtils = NBPhoneNumberUtil()
        return phoneNumberUtils.isViablePhoneNumber(rawNumber ?? "")
    }
    
    public static func validMockedPhoneNumber() -> PhoneModel {
        return PhoneModel(internationalNumber: "+201016939292", prettyNumber: "+20 101 693 9292", trimmedNumber: "1016939292", rawNumber: "1016939292", selectedCountry: Country.egypt())
    }
    
    public struct Country: Equatable {
        public var code:String?
        public var shortName:String?
        public var name:String?
        
        static func egypt() -> Country {
            return Country(code: "+2", shortName: "EG", name: "EGYPT")
        }
    }
    public static func == (lhs: PhoneModel, rhs: PhoneModel) -> Bool {
        return lhs.internationalNumber == rhs.internationalNumber
            && lhs.prettyNumber == rhs.prettyNumber
            && lhs.trimmedNumber == rhs.trimmedNumber
            && lhs.rawNumber == rhs.rawNumber
            && lhs.selectedCountry == rhs.selectedCountry
    }

}

extension FPNTextField {
    func phoneModel() -> PhoneModel {
        PhoneModel(internationalNumber: internationalNumber(),
                   prettyNumber:prettyNumber(),
                   trimmedNumber:  trimmedNumber(),
                   rawNumber: getFormattedPhoneNumber(format: .E164),
                   selectedCountry: selectedCountry())
    }
    
    private func internationalNumber() -> String? {
        return getFormattedPhoneNumber(format: .E164) != "+(null)(null)" ? getFormattedPhoneNumber(format: .E164) : completeFullNumber()
    }
    
    private func prettyNumber() -> String? {
        getFormattedPhoneNumber(format: .International) ?? completeFullNumber()
    }
    
    private func trimmedNumber() -> String? {
        getRawPhoneNumber() ?? "" // completeFullNumber()
    }
    private func selectedCountry() -> PhoneModel.Country {
        return PhoneModel.Country(code: selectedCountry?.phoneCode, shortName: selectedCountry?.code.rawValue, name: selectedCountry?.name)
    }
    
    private func completeFullNumber() -> String {
        if let code = selectedCountry?.phoneCode, let text = text {
            return code + text.replacingOccurrences(of: " ", with: "")
        }else {
            return text ?? ""
        }
    }
}
