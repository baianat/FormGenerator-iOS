//
//  FormGenerator.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 10/03/2021.
//

import UIKit
import Vanguard

public protocol FormGeneratorProtocol {
    var enableRealTimeValidation: Bool { get set }
    var showErrorLabels: Bool { get set }
    var showPlaceholders: Bool { get set }
    var isGenerated: Bool { get }

    func evaluateInput() -> Bool
    func generate(forInput input: Any, inContainer container: UIView)
    func regenerate(inContainer container: UIView)
    func applyStyle(style: FormStyle)
    func setAlignments(alignments: FormAlignments)
    func applyDefaultSelectedValues()
    func scrollToFirstComponentWithErrorState(in scrollView: UIScrollView)
}

public class FormGenerator: FormGeneratorProtocol {
    
    public init() {}
    
    private var components: [FormComponentProtocol] = []
    
    private let vanguard: Vanguard = Vanguard()
    
    private lazy var style = FormStyle()
    private lazy var alignments = FormAlignments()
    private lazy var editingStylizer = EditingStylizer()
    
    //Public Properties
    public var enableRealTimeValidation: Bool = false {
        didSet {
            if enableRealTimeValidation {
                vanguard.startRealtimeValidation()
            } else {
                vanguard.stopRealtimeValidation()
            }
        }
    }
    
    public var showErrorLabels: Bool = true
    
    public var showPlaceholders: Bool = false
    
    public var isGenerated: Bool {
        return !components.isEmpty
    }
    
    //Public Methods
    public func evaluateInput() -> Bool {
        let details = vanguard.getDetailedFormStatus()
        
        for componentStatus in details.components {
            updateErrorStateInComponent(
                vanguardComponent: componentStatus.component,
                validationResult: componentStatus.result
            )
        }
        
        return details.isFormValid()
    }
     
    public func generate(forInput input: Any, inContainer container: UIView) {
        prepareComponents(input: input)
        buildForm(container: container)
    }
    
    public func regenerate(inContainer container: UIView) {
        buildForm(container: container)
    }
    
    public func applyStyle(style: FormStyle) {
        self.style = style
        updateComponentsStyle()
    }
    
    public func setAlignments(alignments: FormAlignments) {
        self.alignments = alignments
    }
    
    public func applyDefaultSelectedValues() {
        let oldValue = enableRealTimeValidation
        enableRealTimeValidation = false
        for component in components {
            component.applyDefaultValues()
        }
        enableRealTimeValidation = oldValue
    }
    
    public func scrollToFirstComponentWithErrorState(in scrollView: UIScrollView) {
        if let errorComponent = components.first(where: { (component) -> Bool in
            !component.isValid()
           }) {
            let offset = errorComponent.getComponentOrigin()
            let translationY = min(100, offset.y - (-44))
            scrollView.setContentOffset(offset.applying(CGAffineTransform(translationX: -offset.x, y: -translationY)), animated: true)
        }
    }
    
    // Private Methods
    private func buildForm(container: UIView) {
        buildFormViews(container: container)
        applyConfigurations()
        updateComponentsStyle()
        applyEditingStylizer()
        vanguard.delegate = self
    }
    
    private func applyConfigurations() {
        for component in components {
            component.applyConfiguration(
                configuration: FormConfiguration(
                    showPlaceholders: showPlaceholders
                )
            )
        }
    }
    
    private func applyEditingStylizer() {
        editingStylizer.applyStyle(style: style)
        for component in components {
            component.applyEditingChangeStyle(using: editingStylizer)
        }
    }
    
    private func updateComponentsStyle() {
        for component in components {
            component.applyStyle(style: style)
        }
    }
    
    private func updateErrorStateInComponent(
        vanguardComponent: VanguardComponent,
        validationResult: ValidationResult
    ) {
        let formComponent = findFormComponent(usingVanguardComponent: vanguardComponent)
        
        switch validationResult {
        case .valid:
            formComponent?.removeErrorState()
            formComponent?.updateSelectedValue()
            
        case .invalid(let resultInfo):
            formComponent?.setErrorState(
                errorMessage: resultInfo.errors.joined(separator: ",\n"),
                shouldHideErrorLabel: !showErrorLabels
            )
            formComponent?.removeSelectedValue()
        }
    }
    
    private func prepareComponents(input: Any) {
        logPrint("Constructing Form:")
        
        let mirror = Mirror(reflecting: input)
        for child in mirror.children {
            let value = child.value
            logPrint(">>>> \(child.label ?? "")", value)
            
            if let descriptor = value as? Descriptor {
                let component = descriptor.createComponent()
                components.append(component)
                component.registerValidation(inVanguard: vanguard)
            }
        }
    }
    
    private func buildFormViews(container: UIView) {
        if let stackView = container as? UIStackView {
            appendViewsInStack(stackView: stackView)
        } else if let scrollView = container as? UIScrollView {
            let stackView = ViewUtils.createStackView(spacing: alignments.componentsSpacing)
            addStackToScrollView(stackView: stackView, scrollView: scrollView)
            appendViewsInStack(stackView: stackView)
        } else {
            let stackView = ViewUtils.createStackView(spacing: alignments.componentsSpacing)
            addStackToView(stackView: stackView, container: container)
            appendViewsInStack(stackView: stackView)
        }
    }
    
    private func addStackToView(stackView: UIStackView, container: UIView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: alignments.sideMargin),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: alignments.verticalMargin)
        ])
    }
    
    private func addStackToScrollView(stackView: UIStackView, scrollView: UIScrollView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor),
            
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor,
                constant: alignments.sideMargin),
            
            stackView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: alignments.verticalMargin),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -16)
        ])
    }
    
    private func appendViewsInStack(stackView: UIStackView) {
        for component in components {
            stackView.addArrangedSubview(component.buildComponent(alignments: alignments))
        }
    }

    deinit {
        vanguard.stopRealtimeValidation()
    }
}

extension FormGenerator: VanguardDelegate {
    public func vanguard(_ vanguard: Vanguard, formStatusDidChange formStatus: ValidationResult) {
        
    }
    
    public func vanguard(
        _ vanguard: Vanguard,
        valueDidChange newValue: Any?,
        forComponent component: VanguardComponent,
        withStatus status: ValidationResult
    ) {
        
        updateErrorStateInComponent(vanguardComponent: component, validationResult: status)
    }
    
    private func findFormComponent(usingVanguardComponent vanguardComponent: VanguardComponent) -> FormComponentProtocol? {
        return components.first { (component) -> Bool in
            component.hasComponent(vanguardComponent: vanguardComponent)
        }
    }
}
