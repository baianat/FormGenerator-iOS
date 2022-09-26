//
//  Descriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

open class Descriptor {
    public var rules: [Rule]
    public var label: String?
    
    public var simplifiedErrorMessage: String?
    
    public init(label: String? = nil, rules: [Rule] = []) {
        self.rules = rules
        self.label = label
    }
    
    open func createComponent() -> FormComponentProtocol {
        fatalError("You must provide a component in the descriptor")
    }
}

