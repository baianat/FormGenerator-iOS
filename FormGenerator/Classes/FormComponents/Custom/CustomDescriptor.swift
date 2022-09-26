//
//  CustomDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation

public class CustomDescriptor<Custom: CustomFormComponent>: Descriptor {
    public init(customComponent: Custom) {
        self.customComponent = customComponent
        super.init(label: nil, rules: [])
    }
    
    public var customComponent: Custom
    
    public override func createComponent() -> FormComponentProtocol {
        return customComponent
    }
}
