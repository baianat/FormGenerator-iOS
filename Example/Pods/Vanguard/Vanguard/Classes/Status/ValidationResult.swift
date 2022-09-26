//
//  ValidationEnum.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import Foundation

public enum ValidationResult: Equatable {
    public static func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
      switch (lhs, rhs) {
        case (.valid, .valid): return true
        case (.invalid(_), .invalid(_)): return true
        
        default: return false
      }
    }
    
    case valid
    case invalid(resultInfo: ValidationResultInfo)
}

public struct ValidationResultInfo {
    public init(states: [VanguardRuleState]) {
        self.states = states
    }
    
    public let states: [VanguardRuleState]
    
    public var numberOfRules: Int {
        return states.count
    }
    
    public var numberOfValidRules: Int {
        return states.filter { (state) -> Bool in
            state.ruleIsValid
        }.count
    }
    
    public var errors: [String] {
        return states.compactMap { (state) in
            state.errorMessage
        }
    }
    
    public var hasErrors: Bool {
        return !errors.isEmpty
    }
    
    public var numberOfInvalidRules: Int {
        return numberOfRules - numberOfValidRules
    }
    
    public var isValid: Bool {
        return numberOfInvalidRules == 0
    }
    
    public static func empty() -> ValidationResultInfo {
        return ValidationResultInfo(states: [])
    }
    
}

public struct VanguardRuleState {
    public init(helperMessage: String? = nil, errorMessage: String? = nil, ruleIsValid: Bool) {
        self.helperMessage = helperMessage
        self.errorMessage = errorMessage
        self.ruleIsValid = ruleIsValid
    }
    
    public let helperMessage: String?
    public let errorMessage: String?
    
    public let ruleIsValid: Bool
}
