//
//  CustomFormComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 01/04/2021.
//

import UIKit
import Vanguard

open class CustomFormComponent: FormComponentProtocol {
    public init() {}
    
    open func buildComponent(alignments: FormAlignments) -> UIView {
        fatalError("buildComponent must be implemented")
    }
    
    open func getComponentLabel() -> String? {
        return nil
    }
    
    open func applyDefaultValues() {
        
    }
    
    open func updateSelectedValue() {
        
    }
    
    open func removeSelectedValue() {
        
    }
    
    open func registerValidation(inVanguard vanguard: Vanguard) {
        
    }
    
    open func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        return false
    }
    
    open func isValid() -> Bool {
        return true
    }
    
    open func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        
    }
    
    open func removeErrorState() {
        
    }
    
    open func applyStyle(style: FormStyle) {
        
    }
    
    open func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        
    }
    
    open func applyConfiguration(configuration: FormConfiguration) {
        
    }
}
