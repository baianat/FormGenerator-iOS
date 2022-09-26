//
//  PrimaryAndSecondaryPickersComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 12/04/2021.
//

import UIKit
import Vanguard

public class PrimaryAndSecondaryPickersComponent: FormComponentProtocol {
    let descriptor: PrimaryAndSecondaryPickersDescriptor
    
    private let key = randomString(length: 4)
    private var alignments = FormAlignments()
    private var style = FormStyle()
    
    private weak var vanguard: Vanguard?
    private var validationCase: ValidationCase?
    
    let primaryFieldsStackView = ViewUtils.createStackView(spacing: 8)
    let titleLabel = ViewUtils.createTitleLabel(title: "")
    let errorLabel = ViewUtils.createErrorLabel()
    
    var pickerHolders: [PickerHolder] = []
    
    let secondaryComponent: MultiplePickersComponent
    
    public init(descriptor: PrimaryAndSecondaryPickersDescriptor) {
        self.descriptor = descriptor
        self.secondaryComponent = MultiplePickersComponent(
            descriptor: descriptor.secondaryDescriptor
        )
        self.secondaryComponent.checkDelegate = self
        self.descriptor.secondaryDescriptor.delegate = self
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        self.alignments = alignments
        let outerStackView = ViewUtils.createStackView(spacing: alignments.componentsSpacing)
        
        primaryFieldsStackView.spacing = alignments.componentInnerSpacing
        
        outerStackView.addArrangedSubview(buildPrimaryFields())
        outerStackView.addArrangedSubview(buildSecondaryFields())
        
        return outerStackView
    }
    
    private func buildPrimaryFields() -> UIView {
        let innerStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        if let title = getComponentLabel() {
            titleLabel.text = title
            innerStackView.addArrangedSubview(titleLabel)
        }
        
        innerStackView.addArrangedSubview(primaryFieldsStackView)
        for index in 0..<descriptor.numberOfPrimaryFields {
            let holder = PickerHolder(
                pickerField: UIPickerViewTextField(),
                selectedValueIndex: -1
            )
            pickerHolders.append(holder)
            
            primaryFieldsStackView.addArrangedSubview(holder.pickerField)
            holder.pickerField.pickerDelegate = self
            holder.pickerField.tag = index
        }
        
        innerStackView.addArrangedSubview(errorLabel)
        
        return innerStackView
    }
    
    private func buildSecondaryFields() -> UIView {
        return secondaryComponent.buildComponent(alignments: alignments)
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        if !descriptor.selectedPrimaryIndices.isEmpty {
            for index in pickerHolders.indices {
                let selectedIndex = descriptor.selectedPrimaryIndices[index]
                pickerHolders[index].pickerField.text = descriptor.values[selectedIndex]
                pickerHolders[index].selectedValueIndex = selectedIndex
            }
            
            secondaryComponent.applyDefaultValues()
            validatePrimaryPickers()
        }
    }
    
    private func validatePrimaryPickers() {
        let selectedCount = pickerHolders.reduce(0) { (result, holder) -> Int in
            return result + (holder.selectedValueIndex != -1 ? 1 : 0)
        }
        vanguard?.validateValue(value: selectedCount, withName: key)
    }
    
    public func updateSelectedValue() {
        descriptor.selectedPrimaryIndices = getSelectedPrimaryIndices()
            
        descriptor.selectedPrimaryValues = descriptor.selectedPrimaryIndices.map({descriptor.values[$0]})
        
        secondaryComponent.updateSelectedValue()
        
        descriptor.selectedSecondaryIndices = getSelectedSecondaryIndices()
        descriptor.selectedSecondaryValues = descriptor.secondaryDescriptor.selectedValues
    }
    
    private func getSelectedPrimaryIndices() -> [Int] {
        return pickerHolders.compactMap(
            {$0.selectedValueIndex != -1 ? $0.selectedValueIndex : nil}
        )
    }
    
    private func getSelectedSecondaryIndices() -> [Int] {
        return descriptor.secondaryDescriptor.selectedIndices
    }
    
    public func removeSelectedValue() {
        descriptor.selectedPrimaryValues = []
        descriptor.selectedPrimaryIndices = []
        descriptor.selectedSecondaryValues = []
        descriptor.selectedSecondaryIndices = []
        
        secondaryComponent.removeSelectedValue()
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        self.vanguard = vanguard
        
        validationCase = vanguard.registerValueComponent(
            withName: key,
            rules: [IntValueRule(predicate: { [weak self] (value) -> Bool in
                guard let self = self else { return false }
                return value == self.descriptor.numberOfPrimaryFields
            })]
        )
        vanguard.validateValue(value: pickerHolders.count, withName: key)
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? String else {
            return false
        }
        return component == key
    }
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        let error: String?
        if descriptor.simplifiedErrorMessage != nil {
            error = descriptor.simplifiedErrorMessage
        } else {
            error = "\(Localize.numberOfItemsCannotBeLessThan()) \(descriptor.numberOfPrimaryFields)"
        }
        
        errorLabel.isHidden = shouldHideErrorLabel || (error == nil)
        errorLabel.text = error
    }
    
    public func removeErrorState() {
        errorLabel.isHidden = true
        errorLabel.text = nil
    }
    
    public func getComponentOrigin() -> CGPoint {
        return titleLabel.getOriginRelativeToSupremeView()
    }
    
    public func applyStyle(style: FormStyle) {
        self.style = style
        titleLabel.font = style.titleLabelFont
        titleLabel.textColor = style.textColor
        titleLabel.insets = UIEdgeInsets(
            top: 0,
            left: style.titleLabelSidePadding,
            bottom: 0,
            right: style.titleLabelSidePadding
        )
        
        errorLabel.font = style.errorLabelFont
        errorLabel.textColor = style.failureColor
        
        for holder in pickerHolders {
            
            holder.pickerField.font = style.textFieldFont
            holder.pickerField.textColor = style.textColor
            
            holder.pickerField.setCornerRadius(value: style.textFieldCornerRadius)
            holder.pickerField.setHeightEqualToConstant(style.textFieldHeight)
            
            setValidBorderColor(textField: holder.pickerField)
        }
        
        secondaryComponent.applyStyle(style: style)
    }
    
    private func setValidBorderColor(textField: UITextField?) {
        let borderColor: UIColor = textField?.isFirstResponder == true ? style.activeBorderColor : style.inactiveBorderColor
        textField?.setStrokeColor(color: borderColor, width: style.textFieldBorderWidth)
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        for holder in pickerHolders {
            editingStylizer.setupTextField(textField: holder.pickerField)
        }
        secondaryComponent.applyEditingChangeStyle(using: editingStylizer)
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
        if configuration.showPlaceholders {
            for holder in pickerHolders {
                holder.pickerField.placeholder = descriptor.primaryFieldPlaceholder
            }
        }
    }
    
    
}

extension PrimaryAndSecondaryPickersComponent: PickerTextFieldDelegate {
    public func pickerTextFieldDidTapPick(_ pickerTextField: UIPickerViewTextField) {
        let index = pickerTextField.tag
        let initalIndex = pickerHolders[index].selectedValueIndex != -1 ? pickerHolders[index].selectedValueIndex : 0
        getRootController()?.presentValuesPicker(
            values: descriptor.values,
            initialSelectionIndex: initalIndex,
            dismissAction: nil,
            submitAction: { [weak self, index] (selectedIndex) in
                self?.submitNewValue(holderIndex: index, selectedIndex: selectedIndex)
            }
        )
    }
    
    private func submitNewValue(holderIndex: Int, selectedIndex: Int) {
        guard !containsSelectedIndex(selectedIndex: selectedIndex) else {
            showTwiceSelectionError()
            return
        }
        
        pickerHolders[holderIndex].selectedValueIndex = selectedIndex
        pickerHolders[holderIndex].pickerField.text = descriptor.values[selectedIndex]
        
        if let secondaryHolderIndex = secondaryComponent.pickerHolders.firstIndex(where: { (holder) -> Bool in
            holder.selectedValueIndex == selectedIndex
        }) {
            secondaryComponent.removeField(at: secondaryHolderIndex)
        }
        validatePrimaryPickers()
        
        self.descriptor.delegate?.primaryAndSecondaryPickersDescriptor(self.descriptor, didChangeSelection: getSelectedPrimaryIndices(), getSelectedSecondaryIndices())
    }
    
    private func showTwiceSelectionError() {
        getRootController()?.showAlert(message: Localize.youCannotSelectTheSameValueTwice())
    }
    
    private func containsSelectedIndex(selectedIndex: Int) -> Bool {
        return pickerHolders.contains(where: {$0.selectedValueIndex == selectedIndex})
    }
}

extension PrimaryAndSecondaryPickersComponent: MultiplePickersComponentCheckDelegate {
    func canCreateNewField(at selectedIndex: Int) -> Bool {
        return !containsSelectedIndex(selectedIndex: selectedIndex)
    }
}

extension PrimaryAndSecondaryPickersComponent: MultiplePickersDescriptorDelegate {
    public func multiplePickersDescriptor(_ descriptor: MultiplePickersDescriptor, didChangeSelection selectedIndices: [Int], _ selectedValues: [String]) {
        self.descriptor.delegate?.primaryAndSecondaryPickersDescriptor(self.descriptor, didChangeSelection: getSelectedPrimaryIndices(), getSelectedSecondaryIndices())
    }
}
