//
//  ValueComponent.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 1/3/21.
//

import Foundation

public class ValueComponent: VanguardComponent {
    public weak var delegate: VanguardComponentDelegate?
    
    public var component: Any?
    
    private var shouldNotify = false
    
    var value: Any? {
        didSet {
            if shouldNotify {
                delegate?.valueDidChange()
            }
        }
    }
    
    public init(namedComponent: String, value: Any?) {
        self.value = value
        self.component = namedComponent
        //delegate?.valueDidChange()
    }
    
    public func registerObserver() {
        shouldNotify = true
    }
    
    public func unregisterObserver() {
        shouldNotify = false
    }
    
    public func getValue() -> Any? {
        return value
    }
    
    
}
