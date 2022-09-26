//
//  UIViewController+VanguardExtensions.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/31/20.
//

import UIKit

extension UIViewController {
    @discardableResult
    public func vanguard(validateTextField textField: UITextField, byRules rules: [Rule]) -> ValidationCase? {
        return findVanguard()?.validate(textField: textField, byRules: rules)
    }
    
    @discardableResult
    public func vanguard(validateTextView textView: UITextView, byRules rules: [Rule]) -> ValidationCase? {
        return findVanguard()?.validate(textView: textView, byRules: rules)
    }
    
    @discardableResult
    public func vanguard(registerValidationForValueWithName name: String, byRules rules: [Rule]) -> ValidationCase? {
        findVanguard()?.registerValueComponent(withName: name, rules: rules)
    }
    
    public func vanguard(validateValue value: Any?, withName name: String) {
        findVanguard()?.validateValue(value: value, withName: name)
    }
    
    private func findVanguard() -> Vanguard? {
        return VanguardUtils.findVanguard(inContainer: self)
    }
}
