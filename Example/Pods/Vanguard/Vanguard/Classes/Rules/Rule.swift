//
//  Rule.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import Foundation

public protocol Rule {
    
    var helperMessage: String? { get }
    
    var errorMessage: String? { get }
    
    func validate(validatable: Any?) -> Bool
    
}

public class StandardRule: Rule {
    public var helperMessage: String? = nil
    
    public var errorMessage: String? = nil
    
    public func validate(validatable: Any?) -> Bool {
        return true
    }
}
