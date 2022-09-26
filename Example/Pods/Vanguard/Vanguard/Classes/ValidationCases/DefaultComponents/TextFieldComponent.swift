//
//  TextFieldComponent.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import UIKit

public class TextFieldComponent: VanguardComponent {
    
    weak public var delegate: VanguardComponentDelegate?
    
    weak var textField: UITextField?
    
    public var component: Any? {
        return textField
    }
    
    public init(textField: UITextField) {
        self.textField = textField
    }
    
    public func registerObserver() {
        textField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange() {
        delegate?.valueDidChange()
    }
    
    public func unregisterObserver() {
        textField?.removeTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    public func getValue() -> Any? {
        return textField?.text ?? ""
    }
    
}

extension UITextField {
    func vanguardComponent() -> VanguardComponent {
        return TextFieldComponent(textField: self)
    }
}

public extension UITextField {
    @discardableResult
    func vanguard(validateInContainer container: Any, byRules rules: [Rule]) -> ValidationCase? {
        return VanguardUtils.findVanguard(inContainer: container)?
            .validate(textField: self, byRules: rules)
    }
}
