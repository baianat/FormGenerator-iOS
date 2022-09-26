//
//  FPNTextFieldVanguardComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 28/03/2021.
//

import UIKit
import Vanguard
import FlagPhoneNumber

class FPNTextFieldVanguardComponent: VanguardComponent {
    weak var delegate: VanguardComponentDelegate?
    
    weak var textField: FPNTextField?
    
    var component: Any? {
        return textField
    }
    
    public init(textField: FPNTextField) {
        self.textField = textField
    }
    
    func registerObserver() {
        textField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange() {
        delegate?.valueDidChange()
    }
    
    func unregisterObserver() {
        textField?.removeTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func getValue() -> Any? {
        return textField?.phoneModel()
    }
}

extension FPNTextField {
    func phoneVanguardComponent() -> VanguardComponent {
        return FPNTextFieldVanguardComponent(textField: self)
    }
}
