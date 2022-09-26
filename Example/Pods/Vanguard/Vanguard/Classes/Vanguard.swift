//
//  Vanguard.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import UIKit

public protocol VanguardDelegate: class {
    func vanguard(
        _ vanguard: Vanguard,
        valueDidChange newValue: Any?,
        forComponent component: VanguardComponent,
        withStatus status: ValidationResult)
    
    func vanguard(
        _ vanguard: Vanguard,
        formStatusDidChange formStatus: ValidationResult)
}

public class Vanguard {
    
    public init(validationCases: [ValidationCase]) {
        self.validationCases = validationCases
    }
    
    public init() {
        self.validationCases = []
    }
    
    private var componentsHolder = ComponentsHolder()
    
    private var validationCases: [ValidationCase]
    
    private var isFormValid = ValidationResult.invalid(resultInfo: .empty())
    private var isRealtimeValidationStarted = false
    
    weak public var delegate: VanguardDelegate?
    
    public func startRealtimeValidation() {
        isRealtimeValidationStarted = true
        for index in validationCases.indices {
            validationCases[index].delegate = self
            validationCases[index].startObserving()
        }
    }
    
    public func stopRealtimeValidation() {
        isRealtimeValidationStarted = false
        for index in validationCases.indices {
            validationCases[index].stopObserving()
            validationCases[index].delegate = nil
        }
    }
    
    private func hasComponent(withName name: String) -> Bool {
        return componentsHolder.findComponent(component: name) != nil
    }
    
    @discardableResult
    public func registerValueComponent(withName name: String, rules: [Rule]) -> ValidationCase? {
        if hasComponent(withName: name) {
            print("Name: \(name) is already assigned to a component")
            return nil
        } else {
            let newComponent = ValueComponent(namedComponent: name, value: nil)
            componentsHolder.components.append(newComponent)
            let validationCase = DefaultValidationCase(
                component: newComponent,
                rules: rules
            )
            addValidationCases(validationCase)
            return validationCase
        }
    }
    
    public func validateValue(value: Any?, withName name: String) {
        if let component = componentsHolder.findComponent(component: name) as? ValueComponent {
            component.value = value
        } else {
            fatalError("You must register a validation with the name \"\(name)\" before validating any values")
        }
    }
    
    public func getFormStatus() -> ValidationResult {
        for index in validationCases.indices {
            let status = validationCases[index].validate()
            if status == .valid {
                continue
            }
            return status
        }
        return .valid
    }
    
    public func getDetailedFormStatus() -> FormStatusResult {
        let components = validationCases.reduce([]) { (result, validationCase) -> [ComponentStatus] in
            let component = ComponentStatus(
                component: validationCase.component,
                result: validationCase.validate())
            var newResult = [ComponentStatus]()
            newResult.append(contentsOf: result)
            newResult.append(component)
            return newResult
        }
        
        return FormStatusResult(components: components)
    }
    
    public func addValidationCases(_ cases: ValidationCase...) {
        validationCases.append(contentsOf: cases)
        if isRealtimeValidationStarted {
            stopRealtimeValidation()
            startRealtimeValidation()
        }
    }
    
    public func removeAllCases() {
        stopRealtimeValidation()
        validationCases.removeAll()
        componentsHolder.components.removeAll()
    }
    
    deinit {
        removeAllCases()
    }
}

extension Vanguard: ValidationCaseDelegate {
    public func valueDidChange(_ component: VanguardComponent, newStatus: ValidationResult) {
        delegate?.vanguard(self, valueDidChange: component.getValue(), forComponent: component, withStatus: newStatus)
        let formStatus = getFormStatus()
        if formStatus != isFormValid {
            isFormValid = formStatus
            delegate?.vanguard(self, formStatusDidChange: formStatus)
        }
    }
}

