//
//  ErrorMessages.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 05/04/2021.
//

import Foundation

public enum ErrorMessages {
    
}

public extension ErrorMessages {
    static let nameMustNotBeEmpty = Localize.nameMustNotBeEmpty()
    static let nameMustNotBeLessThan2Characters = Localize.nameMustNotBeLessThan2Characters()
    static let nameMustNotContainSpecialCharacters = Localize.nameMustNotContainSpecialCharacters()
    static let emailIsNotValid = Localize.emailIsNotValid()
    static let phoneNumberIsNotValid = Localize.phoneNumberIsNotValid()
    static let youMustSelectValue = Localize.youMustSelectValue()
    static let pleaseEnterStrongPassword = Localize.pleaseEnterStrongPassword()
    static let youMustSelectDate = Localize.youMustSelectDate()
    static let youMustSelectItem = Localize.youMustSelectItem()
    static let youMustSelectCountry = Localize.youMustSelectCountry()
    static let fieldCantBeEmpty = Localize.fieldCantBeEmpty()
}
