//
//  EmailOrPhoneFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

//public class EmailOrPhoneFieldDescriptor: Descriptor {
//    public override init(
//        label: String? = nil,
//        rules: [Rule] = [
//            EmailRule(errorMessage: "Email is not valid")
//                .orRule(FPNPhoneNumberRule(errorMessage: "Phone number is not valid"))
//        ]
//    ) {
//        super.init(label: label, rules: rules)
//    }
//
//    public var selectedValue: String?
//    public var isEmail: Bool {
//        return EmailRule().validate(validatable: selectedValue)
//    }
//    public var isPhone: Bool {
//        return FPNPhoneNumberRule().validate(validatable: selectedValue)
//    }
//
//    public override func createComponent() -> FormComponentProtocol {
//        //FIXME: To be created
//        fatalError("Not implemented yet")
//    }
//}
