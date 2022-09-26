//
//  DefaultValidationCase.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import Foundation

public class DefaultValidationCase: ValidationCase {
    public var component: VanguardComponent
    public var rules: [Rule]
    
    weak public var delegate: ValidationCaseDelegate?
    
    public init(component: VanguardComponent, rules: [Rule]) {
        self.rules = rules
        self.component = component
        self.component.delegate = self
    }
    
    public func validate() -> ValidationResult {
        let info = rules.reduce(ValidationResultInfo.empty()) { (result, rule) -> ValidationResultInfo in
            let isValid = rule.validate(validatable: component.getValue())
            var states = [VanguardRuleState]()
            states.append(contentsOf: result.states)
            states.append(VanguardRuleState(
                helperMessage: rule.helperMessage,
                errorMessage: isValid ? nil : rule.errorMessage,
                ruleIsValid: isValid
            ))
            
            return ValidationResultInfo(
                states: states
            )
        }
        return info.isValid ? .valid : .invalid(resultInfo: info)
    }
    
    public func startObserving() {
        component.registerObserver()
    }
    
    public func stopObserving() {
        component.unregisterObserver()
    }

}

extension DefaultValidationCase: VanguardComponentDelegate {
    public func valueDidChange() {
        
        delegate?.valueDidChange(
            component,
            newStatus: validate())
    }
}
