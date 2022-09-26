//
//  HorizontalDualFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation

public class HorizontalDualFieldDescriptor<First: Descriptor, Second: Descriptor>: Descriptor {
    public init(first: First, second: Second) {
        self.first = first
        self.second = second
    }
    
    public let first: First
    public let second: Second
    
    public override func createComponent() -> FormComponentProtocol {
        return HorizontalDualFieldComponent(descriptor: self)
    }
}
