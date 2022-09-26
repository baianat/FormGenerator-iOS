//
//  VanguardComponent.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import Foundation

public protocol VanguardComponentDelegate: class {
    func valueDidChange()
}

public protocol VanguardComponent {
    
    var delegate: VanguardComponentDelegate? { set get }
    
    var component: Any? { get }
    
    func registerObserver()
    func unregisterObserver()
    
    func getValue() -> Any?
}
