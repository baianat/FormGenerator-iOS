//
//  CustomError.swift
//  Utils
//
//  Created by Ahmed Tarek on 12/27/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import Foundation

public class FormCustomError: LocalizedError {
    public init(errorDescription: String) {
        self.errorDescription = errorDescription
    }
    
    public var errorDescription: String?
}

