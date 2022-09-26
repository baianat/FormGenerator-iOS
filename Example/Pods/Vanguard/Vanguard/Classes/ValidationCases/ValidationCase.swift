//
//  ValidationCase.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import Foundation


public protocol ValidationCaseDelegate: class {
    func valueDidChange(_ component: VanguardComponent, newStatus: ValidationResult)
}

public protocol ValidationCase {
    var rules: [Rule] { get set }
    
    var component: VanguardComponent { get set }
    
    var delegate: ValidationCaseDelegate? { get set }
    
    func validate() -> ValidationResult
    
    func startObserving()
    
    func stopObserving()
}
