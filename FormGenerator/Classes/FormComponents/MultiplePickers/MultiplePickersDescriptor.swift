//
//  MultiplePickersDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol MultiplePickersDescriptorDelegate: AnyObject {
    func multiplePickersDescriptor(
        _ descriptor: MultiplePickersDescriptor,
        didChangeSelection selectedIndices: [Int],
        _ selectedValues: [String]
    )
}

public class MultiplePickersDescriptor: Descriptor {
    public init(
        minRequiredPickers: Int = 1,
        maxNumberOfPickers: Int = .max,
        canSelectTheSameItem: Bool = false,
        decorator: MultiplePickersDecorator = MultiplePickersDecorator(),
        label: String? = nil
    ) {
        self.minRequiredPickers = minRequiredPickers
        self.maxNumberOfPickers = maxNumberOfPickers
        self.decorator = decorator
        self.canSelectTheSameItem = canSelectTheSameItem
        super.init(label: label, rules: [])
    }
    
    public weak var delegate: MultiplePickersDescriptorDelegate?
    
    var minRequiredPickers: Int
    var maxNumberOfPickers: Int
    var decorator: MultiplePickersDecorator
    var canSelectTheSameItem: Bool
    
    public var values: [String] = []
    
    public var selectedValues: [String] = []
    public var selectedIndices: [Int] = []
    
    public override func createComponent() -> FormComponentProtocol {
        return MultiplePickersComponent(descriptor: self)
    }
}
