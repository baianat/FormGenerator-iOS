//
//  CustomRules.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 11/03/2021.
//

import Foundation
import Vanguard

public class NameRule: Rule {
    public init() {}
    public var helperMessage: String? {
        return rule.helperMessage
    }
    
    public var errorMessage: String? {
        return rule.errorMessage
    }
    
    private var rule: Rule =
        NotEmptyRule(errorMessage: ErrorMessages.nameMustNotBeEmpty)
        .andRule(
            MinCharLengthRule(
                min: 2,
                errorMessage: ErrorMessages.nameMustNotBeLessThan2Characters))
        .andRule(
            ContainsSpecialCharactersRule(
                errorMessage: ErrorMessages.nameMustNotContainSpecialCharacters).reversed())
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        
        return rule.validate(validatable: text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

public class PasswordNotWeakRule: Rule {
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        
        return !text.isWeakPassword() 
    }
}

public class FPNPhoneNumberRule: Rule {
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public func validate(validatable: Any?) -> Bool {
        guard let phone = validatable as? PhoneModel else {
            return false
        }
        
        return phone.isValidPhoneNumber()
    }
}

public class WebUrlRule: Rule {
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        
        return text.isUrl()
    }
}

public class ContainsLetters: Rule {
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public func validate(validatable: Any?) -> Bool {
        guard let text = validatable as? String else {
            return false
        }
        
        return text.containsLetter()
    }
}

public class IsTrueRule: Rule {
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public func validate(validatable: Any?) -> Bool {
        let boolean = validatable as? Bool
        return boolean == true
    }
}

public class IsFalseRule: Rule {
    public init(errorMessage: String? = nil, helperMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public func validate(validatable: Any?) -> Bool {
        let boolean = validatable as? Bool
        return boolean == false
    }
}

public class IntValueRule: Rule {
    public init(predicate: @escaping IntPredicate, errorMessage: String? = nil, helperMessage: String? = nil) {
        self.predicate = predicate
        self.errorMessage = errorMessage
        self.helperMessage = helperMessage
    }
    
    private var predicate: IntPredicate
    
    public var helperMessage: String?
    
    public var errorMessage: String?
    
    public func validate(validatable: Any?) -> Bool {
        guard let integer = validatable as? Int else {
            return false
        }
        
        return predicate(integer)
    }
}
