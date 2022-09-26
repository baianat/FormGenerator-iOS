//
//  VanguardWrapperValidationCase.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 01/04/2021.
//

import Foundation
import Vanguard

class VanguardWrapperValidationCase: ValidationCase {
    
    var rules: [Rule] = []
    
    private var vanguardWrapperComponent: VanguardWrapperComponent
    
    var component: VanguardComponent {
        get {
            return vanguardWrapperComponent
        }
        
        set {
            
        }
    }
    
    weak var delegate: ValidationCaseDelegate?
    
    init(component: VanguardWrapperComponent) {
        self.vanguardWrapperComponent = component
        self.vanguardWrapperComponent.delegate = self
    }
    
    func validate() -> ValidationResult {
        guard let result = vanguardWrapperComponent.getValue() as? ValidationResult else {
            
            return .invalid(
                resultInfo: ValidationResultInfo(
                    states: [VanguardRuleState(ruleIsValid: false)]
                )
            )
        }
        
        return result
    }
    
    func startObserving() {
        vanguardWrapperComponent.registerObserver()
    }
    
    func stopObserving() {
        vanguardWrapperComponent.unregisterObserver()
    }
    
    
}

extension VanguardWrapperValidationCase: VanguardComponentDelegate {
    func valueDidChange() {
        delegate?.valueDidChange(vanguardWrapperComponent, newStatus: validate())
    }
}
