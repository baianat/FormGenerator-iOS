//
//  Rules+Extensions.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 1/2/21.
//

import Foundation

//utils
extension Rule {
    func combineMessages(_ messages: String?..., separator: String = ",\n") -> String? {
        return messages.reduce(nil) { (result, message) -> String? in
            if message?.isEmpty == false {
                if result == nil {
                    return message
                } else {
                    if message?.isEmpty == false {
                        return (result ?? "") + separator + (message ?? "")
                    }
                    return result
                }
            }
            return result
        }?.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: [","])
    }
}

//public
public extension Rule {
    func andRule(_ rule: Rule) -> Rule {
        return AndRule(firstRule: self, secondRule: rule)
    }
    
    func orRule(_ rule: Rule) -> Rule {
        return OrRule(firstRule: self, secondRule: rule)
    }
    
    func notRequiredIfEmpty() -> Rule {
        return NotRequiredIfEmptyRule(rule: self)
    }
    
    func reversed() -> Rule {
        return ReversedRule(rule: self)
    }
}
