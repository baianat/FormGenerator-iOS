//
//  ComponentProtocol.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 10/03/2021.
//

import UIKit
import Vanguard

public protocol FormComponentSelectedValueProtocol {
    func applyDefaultValues()
    func updateSelectedValue()
    func removeSelectedValue()
}

public protocol FormComponentVanguardProtocol {
    func registerValidation(inVanguard vanguard: Vanguard)
    func hasComponent(vanguardComponent: VanguardComponent) -> Bool
    func isValid() -> Bool
}

public protocol FormComponentErrorProtocol {
    func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool)
    func removeErrorState()
    func getComponentOrigin() -> CGPoint
}

public extension FormComponentErrorProtocol {
    func getComponentOrigin() -> CGPoint {
        return .zero
    }
}

public protocol FormConfigurationProtocol {
    func applyStyle(style: FormStyle)
    func applyEditingChangeStyle(using editingStylizer: EditingStylizer)
    func applyConfiguration(configuration: FormConfiguration)
}

public protocol FormComponentProtocol: FormComponentSelectedValueProtocol,
                                       FormComponentVanguardProtocol,
                                       FormComponentErrorProtocol,
                                       FormConfigurationProtocol {
    func buildComponent(alignments: FormAlignments) -> UIView
    func getComponentLabel() -> String?
}
