//
//  FormConfiguration.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 28/03/2021.
//

import Foundation

public struct FormConfiguration {
    public init(showPlaceholders: Bool) {
        self.showPlaceholders = showPlaceholders
    }
    
    public var showPlaceholders: Bool
}
