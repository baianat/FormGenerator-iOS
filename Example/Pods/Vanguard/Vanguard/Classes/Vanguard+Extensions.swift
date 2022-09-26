//
//  Vanguard+Extensions.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/31/20.
//

import UIKit

extension Vanguard {
    
    @discardableResult
    public func validate(textField: UITextField, byRules rules: [Rule]) -> ValidationCase {
        let validationCase = DefaultValidationCase(
            component: textField.vanguardComponent(), rules: rules)
        addValidationCases(validationCase)
        return validationCase
    }
    
    @discardableResult
    public func validate(textView: UITextView, byRules rules: [Rule]) -> ValidationCase {
        let validationCase = DefaultValidationCase(
            component: textView.vanguardComponent(), rules: rules)
        addValidationCases(validationCase)
        return validationCase
    }
}
