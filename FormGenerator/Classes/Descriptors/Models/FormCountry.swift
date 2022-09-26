//
//  FormCountry.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 25/04/2021.
//

import Foundation

public struct FormCountry {
    public init(countryName: String, countryCode: String) {
        self.countryName = countryName
        self.countryCode = countryCode
    }
    
    public let countryName: String
    public let countryCode: String
}
