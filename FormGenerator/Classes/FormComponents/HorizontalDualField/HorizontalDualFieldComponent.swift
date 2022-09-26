//
//  HorizontalDualFieldComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 31/03/2021.
//

import UIKit
import Vanguard

public class HorizontalDualFieldComponent<First: Descriptor, Second: Descriptor>: FormComponentProtocol {
    private let descriptor: HorizontalDualFieldDescriptor<First, Second>
    
    private let first: FormComponentProtocol
    private let second: FormComponentProtocol
    
    public init(descriptor: HorizontalDualFieldDescriptor<First, Second>) {
        self.descriptor = descriptor
        self.first = descriptor.first.createComponent()
        self.second = descriptor.second.createComponent()
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(
            createStackWithFiller(
                wrapAround: first.buildComponent(alignments: alignments)))
        stackView.addArrangedSubview(
            createStackWithFiller(
                wrapAround: second.buildComponent(alignments: alignments)))
        
        return stackView
    }
    
    private func createStackWithFiller(wrapAround view: UIView) -> UIStackView {
        let stackView = ViewUtils.createStackView(spacing: 0)
        let fillerView = UIView()
        fillerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(fillerView)
        
        return stackView
    }
    
    public func getComponentLabel() -> String? {
        return nil
    }
    
    public func applyDefaultValues() {
        first.applyDefaultValues()
        second.applyDefaultValues()
    }
    
    public func updateSelectedValue() {
        if first.isValid() {
            first.updateSelectedValue()
        }
        
        if second.isValid() {
            second.updateSelectedValue()
        }
    }
    
    public func removeSelectedValue() {
        if !first.isValid() {
            first.removeSelectedValue()
        }
        
        if !second.isValid() {
            second.removeSelectedValue()
        }
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        first.registerValidation(inVanguard: vanguard)
        second.registerValidation(inVanguard: vanguard)
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        return first.hasComponent(vanguardComponent: vanguardComponent) ||
            second.hasComponent(vanguardComponent: vanguardComponent)
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        if !first.isValid() {
            first.setErrorState(errorMessage: errorMessage, shouldHideErrorLabel: shouldHideErrorLabel)
        }
        
        if !second.isValid() {
            second.setErrorState(errorMessage: errorMessage, shouldHideErrorLabel: shouldHideErrorLabel)
        }
    }
    
    public func removeErrorState() {
        if first.isValid() {
            first.removeErrorState()
        }
        
        if second.isValid() {
            second.removeErrorState()
        }
    }
    
    public func getComponentOrigin() -> CGPoint {
        return first.getComponentOrigin()
    }
    
    public func applyStyle(style: FormStyle) {
        first.applyStyle(style: style)
        second.applyStyle(style: style)
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        first.applyEditingChangeStyle(using: editingStylizer)
        second.applyEditingChangeStyle(using: editingStylizer)
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
        first.applyConfiguration(configuration: configuration)
        second.applyConfiguration(configuration: configuration)
    }
    
    public func isValid() -> Bool {
        return first.isValid() && second.isValid()
    }
}
