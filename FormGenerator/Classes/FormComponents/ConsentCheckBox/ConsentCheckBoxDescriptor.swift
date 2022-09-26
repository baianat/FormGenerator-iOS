//
//  ConsentCheckBoxDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol ConsentCheckBoxDescriptorDelegate: class {
    func consentCheckBoxDescriptor(
        _ descriptor: ConsentCheckBoxDescriptor,
        shouldOpenUrl url: URL
    ) -> Bool
}

public class ConsentCheckBoxDescriptor: Descriptor {

    public init(decorator: ConsentDecorator, defaultValue: Bool = false) {
        self.selectedValue = defaultValue
        self.decorator = decorator
        super.init(rules: [IsTrueRule()])
    }

    public weak var delegate: ConsentCheckBoxDescriptorDelegate?
    
    public var decorator: ConsentDecorator
    
    public var selectedValue: Bool = false
    
    public override func createComponent() -> FormComponentProtocol {
        return ConsentComponent(descriptor: self)
    }
}
