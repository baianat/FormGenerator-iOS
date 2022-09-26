//
//  CountryPickerFieldDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 25/04/2021.
//

import Foundation
import Vanguard

public enum CountriesList {
    case all
    case with(countryCodes: [String])
    case without(countryCodes: [String])
}

public protocol CountryPickerFieldDescriptorDelegate: class {
    func countryPickerFieldDescriptor(
        _ descriptor: CountryPickerFieldDescriptor,
        didSelectCountry: FormCountry?
    )
}

public class CountryPickerFieldDescriptor: Descriptor {
    public init(
        countriesList: CountriesList = .all,
        label: String? = nil,
        rules: [Rule] = [
            NotNilRule(errorMessage: ErrorMessages.youMustSelectCountry)
        ]
    ) {
        self.countriesList = countriesList
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: CountryPickerFieldDescriptorDelegate?
    
    public var countriesList: CountriesList
    public var selectedCountry: FormCountry?
    
    public override func createComponent() -> FormComponentProtocol {
        return CountryPickerFieldComponent(descriptor: self)
    }
}
