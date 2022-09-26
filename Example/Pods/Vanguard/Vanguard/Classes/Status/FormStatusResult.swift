//
//  FormStatusResult.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 23/03/2021.
//

import Foundation

public struct FormStatusResult {
    public let components: [ComponentStatus]
    
    public func isFormValid() -> Bool {
        return components.allSatisfy { (status) -> Bool in
            status.result == .valid
        }
    }
}

public struct ComponentStatus {
    public let component: VanguardComponent
    public let result: ValidationResult
}
