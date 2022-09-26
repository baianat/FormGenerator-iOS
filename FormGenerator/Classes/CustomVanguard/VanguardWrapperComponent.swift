//
//  VanguardWrapperComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 31/03/2021.
//

import Foundation
import Vanguard

class VanguardWrapperComponent: VanguardComponent {
    weak var delegate: VanguardComponentDelegate?
    
    private weak var vanguard: Vanguard?
    private var vanguardDelegateWrapper: VanguardDelegateWrapper?
    
    var component: Any? {
        return vanguard
    }
    
    init(vanguard: Vanguard) {
        self.vanguard = vanguard
    }
    
    func registerObserver() {
        vanguardDelegateWrapper = VanguardDelegateWrapper(first: self, second: vanguard?.delegate)
        vanguard?.delegate = vanguardDelegateWrapper
        vanguard?.startRealtimeValidation()
    }
    
    func unregisterObserver() {
        vanguard?.delegate = vanguardDelegateWrapper?.secondWrapped
        vanguardDelegateWrapper = nil
        vanguard?.stopRealtimeValidation()
    }
    
    func getValue() -> Any? {
        return vanguard?.getFormStatus()
    }
    
}

extension VanguardWrapperComponent: VanguardDelegate {
    func vanguard(_ vanguard: Vanguard, valueDidChange newValue: Any?, forComponent component: VanguardComponent, withStatus status: ValidationResult) {
        delegate?.valueDidChange()
    }
    
    func vanguard(_ vanguard: Vanguard, formStatusDidChange formStatus: ValidationResult) {
    }
}

class VanguardDelegateWrapper: VanguardDelegate {
    weak var firstWrapped: VanguardDelegate?
    weak var secondWrapped: VanguardDelegate?
    
    init(first: VanguardDelegate?, second: VanguardDelegate?) {
        self.firstWrapped = first
        self.secondWrapped = second
    }
    
    func vanguard(_ vanguard: Vanguard, valueDidChange newValue: Any?, forComponent component: VanguardComponent, withStatus status: ValidationResult) {
        firstWrapped?.vanguard(vanguard, valueDidChange: newValue, forComponent: component, withStatus: status)
        secondWrapped?.vanguard(vanguard, valueDidChange: newValue, forComponent: component, withStatus: status)
    }
    
    func vanguard(_ vanguard: Vanguard, formStatusDidChange formStatus: ValidationResult) {
        firstWrapped?.vanguard(vanguard, formStatusDidChange: formStatus)
        secondWrapped?.vanguard(vanguard, formStatusDidChange: formStatus)
    }
}
