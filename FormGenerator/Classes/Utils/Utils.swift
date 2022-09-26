//
//  Utils.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 10/03/2021.
//

import Foundation
import Navajo_Swift
import FlagPhoneNumber
import UIKit

func logPrint(_ items: Any...) {
    #if DEBUG
    print(items)
    #endif
}


func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map { _ in letters.randomElement()! })
}

extension String {
    
    func internationalPhoneNumber() -> String {
        let phoneNumberUtils = NBPhoneNumberUtil()
        let number =   try? phoneNumberUtils.parse(self, defaultRegion: "ZZ")
        if let number = number {
            if let formatterNumber = try? phoneNumberUtils.format(number, numberFormat: .E164) {
                return formatterNumber
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    func prettyPhoneNumber() -> String {
        let phoneNumberUtils = NBPhoneNumberUtil()
        let number =   try? phoneNumberUtils.parse(self, defaultRegion: "ZZ")
        if let number = number {
            if let formatterNumber = try? phoneNumberUtils.format(number, numberFormat: .INTERNATIONAL).trimmingCharacters(in: .whitespaces) {
                return formatterNumber
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    func rawPhoneNumber() -> String {
        let phoneNumberUtils = NBPhoneNumberUtil()
        let number =   try? phoneNumberUtils.parse(self, defaultRegion: "ZZ")
        if let number = number {
            if let formatterNumber = try? phoneNumberUtils.format(number, numberFormat: .NATIONAL) {
                return formatterNumber
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    func isWeakPassword() -> Bool {
        (
            Navajo.strength(ofPassword: self) == .weak ||
            Navajo.strength(ofPassword: self) == .veryWeak ||
            self.count <= 7
        )
    }
    
    func appendWithSpace(_ texts: String...) -> String {
        var new = self
        for text in texts {
            new  += " \(text)"
        }
        return new
    }
    
    func isEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isUrl () -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
    func containsSpecialChars() -> Bool {
        let specialCharsSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
        return self.rangeOfCharacter(from: specialCharsSet) != nil
    }
    
    func containsLetter() -> Bool {
        let letters = NSCharacterSet.letters
        let range = self.rangeOfCharacter(from: letters)
        return range != nil
    }
    
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension PhoneModel {
    func isValidPhoneNumber() -> Bool {
        let phoneUtils = NBPhoneNumberUtil()
        let parsedPhone = try? phoneUtils.parse(rawNumber, defaultRegion: selectedCountry?.code)
        return phoneUtils.isValidNumber(parsedPhone)
    }
}

extension Date {
    func format_ddMMyyyy() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}

func getRootController() -> UIViewController? {
    UIApplication.shared.windows.first { (window) -> Bool in
        return window.isKeyWindow
    }?.rootViewController
}
