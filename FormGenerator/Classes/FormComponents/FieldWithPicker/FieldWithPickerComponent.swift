//
//  FieldWithPickerComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 12/09/2021.
//

import UIKit
import Vanguard

public class FieldWithPickerComponent: FormComponentProtocol {
   
    public var textField: OutlinedTextField
    private var descriptor: FieldWithPickerDescriptor
    
    private var titleLabel: FormLabel?
    private let errorLabel = ViewUtils.createErrorLabel()
    
    private var subPickerView: UIView!
    private let pickerLabel = ViewUtils.createSubPickerLabel()
    private let dividerView = ViewUtils.createDividerForHorizontalStack()
    
    private weak var vanguard: Vanguard?
    private let key = randomString(length: 4)
    
    private var fieldValidationCase: ValidationCase?
    private var pickerValidationCase: ValidationCase?
    
    private var style = FormStyle()
    
    private var selectedIndex: Int? {
        didSet {
            guard oldValue != selectedIndex else {
                return
            }
            
            var value: String? = nil
            
            if let index = selectedIndex, index < descriptor.pickerValues.count {
                value = descriptor.pickerValues[index]
                
            }
            pickerLabel.text = value
            vanguard?.validateValue(value: value, withName: key)
        }
    }
    
    public init(textField: OutlinedTextField, descriptor: FieldWithPickerDescriptor) {
        self.textField = textField
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        initSubPickerView()
        textField.keyboardType = descriptor.decorator.fieldKeyboardType
        textField.leftView = subPickerView
        textField.leftViewMode = .always
        
        if let title = self.getComponentLabel() {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            stackView.addArrangedSubview(titleLabel!)
        }
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabel)
        
        return stackView
    }
    
    private func initSubPickerView() {
        let rect = CGRect(
            x: 0,
            y: 0,
            width: descriptor.decorator.pickerWidth,
            height: style.textFieldHeight
        )
        subPickerView = UIView(frame: rect)
        subPickerView.setWidthEqualToConstant(descriptor.decorator.pickerWidth)
        subPickerView.setHeightEqualToConstant(style.textFieldHeight)
        
        let horizontalStackView = ViewUtils.createStackView(spacing: 4)
        horizontalStackView.axis = .horizontal
        horizontalStackView.fillIn(container: subPickerView)
        
        horizontalStackView.addArrangedSubview(ViewUtils.createZeroWidthFillerView())
        horizontalStackView.addArrangedSubview(pickerLabel)
        horizontalStackView.addArrangedSubview(dividerView)
        
        applyPickerDecorator()
        setupPickingAction()
    }
    
    private func setupPickingAction() {
        subPickerView.isUserInteractionEnabled = true
        subPickerView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(pickerTapGestureHandler)
            )
        )
    }
    
    @objc func pickerTapGestureHandler() {
        guard !descriptor.pickerValues.isEmpty else {
            
            getRootController()?.showAlert(message: Localize.thereAreNoValuesToSelectFrom()) { [weak self] in
                self?.setValidBorderColor()
            }
            return
        }
        
        if selectedIndex != nil && descriptor.pickerValues.count == 1 {
            selectedIndex = 0
            return
        }
        
        getRootController()?.presentValuesPicker(
            title: descriptor.pickerAlertTitle ?? "",
            message: nil,
            values: descriptor.pickerValues,
            initialSelectionIndex: selectedIndex ?? 0,
            dismissAction: { [weak self] in
                self?.setValidBorderColor()
            },
            submitAction: { [weak self] selectedIndex in
                guard let self = self else { return }
                self.selectedIndex = selectedIndex
                self.notifyDelegateSelectedIndexChanged(selectedIndex: selectedIndex)
                self.setValidBorderColor()
            }
        )
    }
    
    func notifyDelegateSelectedIndexChanged(selectedIndex: Int) {
        descriptor.delegate?.fieldWithPickerDescriptor(
            descriptor,
            didSelectItemAt: selectedIndex
        )
    }
    
    private func applyPickerDecorator() {
        subPickerView.backgroundColor = descriptor.decorator.pickerBackgroundColor
        pickerLabel.textColor = descriptor.decorator.pickerTextColor
        pickerLabel.font = descriptor.decorator.pickerTextFont
        subPickerView.setWidthEqualToConstant(descriptor.decorator.pickerWidth)
        
        textField.editingRectInsets = UIEdgeInsets(
            top: 0,
            left: descriptor.decorator.pickerWidth +
                FormDefaultAspects.textFieldLeadingPadding,
            bottom: 0,
            right: FormDefaultAspects.textFieldLeadingPadding
        )
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        selectedIndex = descriptor.pickerSelectedIndex
        textField.text = descriptor.fieldSelectedValue
    }
    
    public func updateSelectedValue() {
        descriptor.fieldSelectedValue = textField.text
        descriptor.pickerSelectedIndex = selectedIndex
    }
    
    public func removeSelectedValue() {
        descriptor.fieldSelectedValue = nil
        descriptor.pickerSelectedIndex = nil
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        self.vanguard = vanguard
        pickerValidationCase = vanguard.registerValueComponent(withName: key, rules: descriptor.pickerRules)
        fieldValidationCase = vanguard.validate(textField: textField, byRules: descriptor.rules)
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        return isFieldComponent(vanguardComponent: vanguardComponent) ||
            isPickerComponent(vanguardComponent: vanguardComponent)
    }
    
    private func isFieldComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? UITextField else {
            return false
        }
        return component === textField
    }
    
    private func isPickerComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? String else {
            return false
        }
        return component == key
    }
    
    public func isValid() -> Bool {
        return isFieldValid() &&
            isPickerValid()
    }
    
    private func isFieldValid() -> Bool {
        return fieldValidationCase?.validate() == .valid
    }
    
    private func isPickerValid() -> Bool {
        return pickerValidationCase?.validate() == .valid
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        var errors = [String]()
        if let error = getFieldErrorMessage(errorMessage: errorMessage) {
            errors.append(error)
        }
        if let error = getPickerErrorMessage(errorMessage: errorMessage) {
            errors.append(error)
        }
        
        let error = errors.joined(separator: ",\n")
        
        errorLabel.isHidden = shouldHideErrorLabel || (error.isEmpty)
        errorLabel.text = error
        
        textField.setStrokeColor(color: style.failureColor, width: style.textFieldBorderWidth)
        dividerView.backgroundColor = style.failureColor
    }
    
    private func getFieldErrorMessage(errorMessage: String?) -> String? {
        guard !isFieldValid() else {
            return nil
        }
        if descriptor.simplifiedErrorMessage != nil {
            return descriptor.simplifiedErrorMessage
        } else {
            return errorMessage
        }
    }
    
    private func getPickerErrorMessage(errorMessage: String?) -> String? {
        guard !isPickerValid() else {
            return nil
        }
        if descriptor.pickerErrorMessage != nil {
            return descriptor.pickerErrorMessage
        } else {
            return errorMessage
        }
    }
    
    public func removeErrorState() {
        errorLabel.isHidden = true
        errorLabel.text = nil
        
        setValidBorderColor()
    }
    
    public func applyStyle(style: FormStyle) {
        self.style = style
        titleLabel?.font = style.titleLabelFont
        titleLabel?.textColor = style.textColor
        
        titleLabel?.insets = UIEdgeInsets(
            top: 0,
            left: style.titleLabelSidePadding,
            bottom: 0,
            right: style.titleLabelSidePadding
        )
        
        errorLabel.font = style.errorLabelFont
        errorLabel.textColor = style.failureColor
        
        textField.font = style.textFieldFont
        textField.textColor = style.textColor
        
        textField.setCornerRadius(value: style.textFieldCornerRadius)
        textField.setHeightEqualToConstant(style.textFieldHeight)
        
        applyPickerDecorator()
        setValidBorderColor()
    }
    
    private func setValidBorderColor() {
        let borderColor: UIColor = textField.isFirstResponder == true ? style.activeBorderColor : style.inactiveBorderColor
        textField.setStrokeColor(color: borderColor, width: style.textFieldBorderWidth)
        dividerView.setWidthEqualToConstant(style.textFieldBorderWidth)
        dividerView.backgroundColor = borderColor
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        editingStylizer.setupTextField(textField: textField)
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
        if configuration.showPlaceholders {
            textField.placeholder = descriptor.label
        }
    }
}
