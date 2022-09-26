//
//  ComponentsHolder.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 1/5/21.
//

import Foundation

class ComponentsHolder {
    var components: [VanguardComponent] = []
    
    init() { }
    
    func findComponent(component: String) -> VanguardComponent? {
        return components.first { (item) -> Bool in
            guard let subject = item.component as? String else {
                return false
            }
            return subject == component
        }
    }
}
