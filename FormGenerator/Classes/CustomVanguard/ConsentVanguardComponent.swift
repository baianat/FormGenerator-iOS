//
//  ConsentVanguardComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard

public class ConsentVanguardComponent: VanguardComponent {
    weak public var delegate: VanguardComponentDelegate?
    
    weak var consentView: ConsentView?
    
    public var component: Any? {
        return consentView
    }
    
    public init(consentView: ConsentView) {
        self.consentView = consentView
    }
    
    public func registerObserver() {
        //left intentionally
    }
    
    public func unregisterObserver() {
        //left intentionally
    }
    
    public func getValue() -> Any? {
        consentView?.isChecked
    }
}

extension ConsentView {
    func vanguardComponent() -> VanguardComponent {
        return ConsentVanguardComponent(consentView: self)
    }
}
