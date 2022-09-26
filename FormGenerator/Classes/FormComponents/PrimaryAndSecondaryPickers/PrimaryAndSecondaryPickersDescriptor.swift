//
//  PrimaryAndSecondaryPickersDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation

public protocol PrimaryAndSecondaryPickersDescriptorDelegate: class {
    func primaryAndSecondaryPickersDescriptor(
        _ descriptor: PrimaryAndSecondaryPickersDescriptor,
        didChangeSelection selectedPrimaryIndices: [Int],
        _ selectedSecondaryIndices: [Int]
    )
}

public class PrimaryAndSecondaryPickersDescriptor: Descriptor {
    public init(
        numberOfPrimaryFields: Int = 1,
        primaryLabel: String? = nil,
        secondaryLabel: String? = nil,
        primaryFieldPlaceholder: String? = nil,
        decorator: MultiplePickersDecorator = MultiplePickersDecorator()
    ) {
        self.numberOfPrimaryFields = numberOfPrimaryFields
        self.primaryFieldPlaceholder = primaryFieldPlaceholder
        self.secondaryDescriptor = MultiplePickersDescriptor(
            minRequiredPickers: 0,
            maxNumberOfPickers: .max,
            canSelectTheSameItem: false,
            decorator: decorator,
            label: secondaryLabel
        )
        super.init(label: primaryLabel, rules: [])
    }
    
    public weak var delegate: PrimaryAndSecondaryPickersDescriptorDelegate?
    
    var numberOfPrimaryFields: Int
    var primaryFieldPlaceholder: String?
    
    var secondaryDescriptor: MultiplePickersDescriptor
    
    public var values: [String] = [] {
        didSet {
            secondaryDescriptor.values = values
        }
    }
    
    public var selectedPrimaryIndices: [Int] = []
    public var selectedPrimaryValues: [String] = []
    
    public var selectedSecondaryIndices: [Int] = [] {
        didSet {
            secondaryDescriptor.selectedIndices = selectedSecondaryIndices
        }
    }
    public var selectedSecondaryValues: [String] = [] {
        didSet {
            secondaryDescriptor.selectedValues = selectedSecondaryValues
        }
    }
    
    public override func createComponent() -> FormComponentProtocol {
        return PrimaryAndSecondaryPickersComponent(descriptor: self)
    }
}
