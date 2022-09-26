//
//  VanguardUtils.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/31/20.
//

import Foundation

class VanguardUtils {
    static func findVanguard(inContainer container: Any) -> Vanguard? {
        let mirror = Mirror(reflecting: container)
        return mirror.children.first { (child) -> Bool in
            child.value is Vanguard
        }?.value as? Vanguard
    }
}
