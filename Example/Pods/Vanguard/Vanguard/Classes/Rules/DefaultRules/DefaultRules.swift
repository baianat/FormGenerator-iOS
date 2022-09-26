//
//  DefaultRules.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 1/2/21.
//

import UIKit

public class TwitterRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        
        return text.contains("twitter")
    }
}

public class FacebookRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        return text.contains("facebook")
    }
}

public class InstagramRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        return text.contains("instagram")
    }
}

public class UrlRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        
        if let url = URL(string: text) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
//    public func validate(text: String) -> Bool {
//        if !isRequired && text.isEmpty {
//            return true
//        }
//
//    }
    
}

public class EmailRule: Rule {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
}


public class NotEmptyRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        return !text.isEmpty
    }
}

public class PhoneNumberRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        let phoneRegEX = "^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\./0-9]*$"
        let phoneTest = NSPredicate.init(format: "SELF MATCHES %@", phoneRegEX)
        return phoneTest.evaluate(with: text)
    }
}

public class MinCharLengthRule: Rule {
    let min: Int
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(min: Int, errorMessage: String? = nil, helperMessage: String? = nil) {
        self.min = min
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        return text.count >= min
    }
}

public class NumericRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        let number = Double(text)
        return number != nil
    }
}

public class IsEmailOrPhoneRule: Rule {
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        return EmailRule().validate(validatable: text) ||
            NumericRule().validate(validatable: text)
    }
}

public class PasswordMatchRule: Rule {
    weak var textField: UITextField!
    public var errorMessage: String?
    public var helperMessage: String?
    
    public init(
        textField: UITextField,
        helperMessage: String? = nil,
        errorMessage: String? = nil
    ) {
        self.textField = textField
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        return textField.text == text
    }
}

class NotRequiredIfEmptyRule: Rule {
    init(rule: Rule, helperMessage: String? = nil, errorMessage: String? = nil) {
        self.rule = rule
        self.helper = helperMessage
        self.error = errorMessage
    }
    
    let rule: Rule
    let error: String?
    let helper: String?
    
    var helperMessage: String? {
        if helper != nil {
            return helper
        } else {
            return rule.helperMessage
        }
    }
    
    var errorMessage: String? {
        if error != nil {
            return error
        } else {
            return rule.errorMessage
        }
    }
    
    func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String, !text.isEmpty else {
            return true
        }
        return rule.validate(validatable: validatable)
    }
}

public class OrRule: Rule {
    let firstRule: Rule
    let secondRule: Rule
    
    public var helperMessage: String? {
        if helper != nil {
            return helper
        } else {
            return combineMessages(
                firstRule.helperMessage, secondRule.helperMessage,
                separator: " Or "
            )
        }
    }
    
    public var errorMessage: String? {
        if error != nil {
            return error
        } else {
            return combineMessages(
                firstRule.errorMessage, secondRule.errorMessage,
                separator: " Or "
            )
        }
    }
    
    private let error: String?
    private let helper: String?
    
    public init(
        firstRule: Rule,
        secondRule: Rule,
        helperMessage: String? = nil,
        errorMessage: String? = nil
    ) {
        self.helper = helperMessage
        self.error = errorMessage
        self.firstRule = firstRule
        self.secondRule = secondRule
    }
    
    public func validate(validatable: Any?) -> Bool {
        return firstRule.validate(validatable: validatable) ||
            secondRule.validate(validatable: validatable)
    }
}

public class AndRule: Rule {
    let firstRule: Rule
    let secondRule: Rule
    public var helperMessage: String? {
        if helper != nil {
            return helper
        } else {
            return combineMessages(firstRule.helperMessage, secondRule.helperMessage)
        }
    }
    
    public var errorMessage: String? {
        if error != nil {
            return error
        } else {
            return combineMessages(firstRule.errorMessage, secondRule.errorMessage)
        }
    }
    
    private let error: String?
    private let helper: String?
    
    public init(
        firstRule: Rule,
        secondRule: Rule,
        helperMessage: String? = nil,
        errorMessage: String? = nil
    ) {
        self.helper = helperMessage
        self.error = errorMessage
        self.firstRule = firstRule
        self.secondRule = secondRule
    }
    
    public func validate(validatable: Any?) -> Bool {
        return firstRule.validate(validatable: validatable) &&
            secondRule.validate(validatable: validatable)
    }
}

public class ReversedRule: Rule {
    let rule: Rule
    
    public init(rule: Rule) {
        self.rule = rule
    }
    
    public var helperMessage: String? {
        return rule.helperMessage
    }
    
    public var errorMessage: String? {
        return rule.errorMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        return !rule.validate(validatable: validatable)
    }
}

public class ContainsSpecialCharactersRule: Rule {
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        return containsSpecialChars(text: text)
    }
    
    private func containsSpecialChars(text: String) -> Bool {
        let specialCharsSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
        return text.rangeOfCharacter(from: specialCharsSet) != nil
    }
}

public class NotNilRule: Rule {
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public func validate(validatable: Any?) -> Bool {
        return validatable != nil
    }
}
