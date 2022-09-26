//
//  RadioButtonsComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 14/04/2021.
//

import UIKit
import M13Checkbox
import Vanguard

extension FormAxis {
    func mapToStackViewAxis() -> NSLayoutConstraint.Axis {
        switch self {
        case .vertical:
            return .vertical
        case .horizontal:
            return .horizontal
        }
    }
}

public class RadioButtonsComponent: FormComponentProtocol {
    let descriptor: RadioButtonsDescriptor
    
    let titleLabel = ViewUtils.createTitleLabel(title: "")
    let errorLabel = ViewUtils.createErrorLabel()
    
    var optionHolders: [OptionHolder] = []
    
    var alignments = FormAlignments()
    var style = FormStyle()
    
    weak var vanguard: Vanguard?
    var validationCase: ValidationCase?
    let key = randomString(length: 4)
    
    init(descriptor: RadioButtonsDescriptor) {
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        self.alignments = alignments
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        if let title = getComponentLabel() {
            titleLabel.text = title
            stackView.addArrangedSubview(titleLabel)
        }
        
        let innerStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        innerStackView.axis = descriptor.axis.mapToStackViewAxis()
        if innerStackView.axis == .horizontal {
            innerStackView.distribution = .fillEqually
        } else {
            innerStackView.distribution = .fill
        }
        
        for option in descriptor.options {
            let holder = createOptionHolder(option: option)
            holder.delegate = self
            optionHolders.append(holder)
            innerStackView.addArrangedSubview(createOptionView(holder: holder, tag: optionHolders.count - 1))
        }
        
        stackView.addArrangedSubview(innerStackView)
        
        stackView.addArrangedSubview(errorLabel)
        
        return stackView
    }
    
    private func createOptionHolder(option: RadioButtonOption) -> OptionHolder {
        switch option {
            case .normal(title: let title):
                return createNormalOptionHolder(description: title)
            case .withTextField(placeholder: let placeholder, let contract):
                return createTextFieldOptionHolder(placeholder: placeholder, contract: contract)
        }
    }
    
    private func createNormalOptionHolder(description: String) -> OptionHolder {
        let checkBox = createCheckBox()
        let descriptionLabel = ViewUtils.createDescriptionLabel(description: description)
        
        return NormalOptionHolder(
            checkBox: checkBox,
            descriptionView: descriptionLabel,
            decorator: descriptor.decorator.labelDecorator
        )
    }
    
    private func createTextFieldOptionHolder(placeholder: String, contract: TextFieldContract) -> OptionHolder {
        let checkBox = createCheckBox()
        let textField = createTextField()
        textField.placeholder = placeholder
        
        return TextFieldOptionHolder(
            checkBox: checkBox,
            textField: textField,
            contract: contract,
            decorator: descriptor.decorator.textFieldDecorator,
            textFieldDelegate: self
        )
    }
    
    private func createTextField() -> OutlinedTextField {
        let textField = OutlinedTextField()
        return textField
    }
    
    private func createCheckBox() -> M13Checkbox {
        let checkBox = M13Checkbox()
        checkBox.stateChangeAnimation = .bounce(.fill)
        checkBox.tintColor = descriptor.decorator.fillColor
        checkBox.secondaryTintColor = descriptor.decorator.fillColor
        checkBox.secondaryCheckmarkTintColor = descriptor.decorator.checkColor
        checkBox.boxLineWidth = 2
        checkBox.checkmarkLineWidth = 2
        return checkBox
    }
    
    private func createOptionView(holder: OptionHolder, tag: Int) -> UIView {
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        stackView.axis = .horizontal
        
        let checkBoxContainer = UIView()
        holder.checkBox.centerIn(container: checkBoxContainer)
        holder.checkBox.setHeightEqualToConstant(24)
        holder.checkBox.setWidthEqualToConstant(24)
        holder.checkBox.isUserInteractionEnabled = false
    
        checkBoxContainer.isUserInteractionEnabled = true
        checkBoxContainer.translatesAutoresizingMaskIntoConstraints = false
        checkBoxContainer.setWidthEqualToConstant(24)
        checkBoxContainer.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(checkTapGestureHandler(_:))
            )
        )
        
        holder.setCheckActionOnSupplementaryView()
        
        checkBoxContainer.tag = tag
        holder.checkBox.tag = tag
        holder.supplementaryView.tag = tag
        
        stackView.addArrangedSubview(checkBoxContainer)
        stackView.addArrangedSubview(holder.supplementaryView)
        
        return stackView
    }
    
    @objc func checkTapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        checkAction(onView: gestureRecognizer.view)
    }
    
    private func checkAction(onView view: UIView?) {
        let selectedIndex = view?.tag
        for holder in optionHolders {
            holder.isChecked =
                holder.checkBox.tag == selectedIndex
        }
        
        let optionValue: RadioButtonValue?
        if let index = selectedIndex {
            optionValue = optionHolders[index].getValue(index: index)
        } else {
            optionValue = nil
        }
        vanguard?.validateValue(value: optionValue, withName: key)
        
        descriptor.delegate?.radioButtonsDescriptor(descriptor, didChangeSelection: getCheckedOptionIndex())
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        for index in optionHolders.indices {
            let holder = optionHolders[index]
            holder.isChecked = index == descriptor.selectedOption?.selectedIndex()
        }
        vanguard?.validateValue(value: descriptor.selectedOption, withName: key)
    }
    
    public func updateSelectedValue() {
        descriptor.selectedOption = getCheckedOption()
    }
    
    private func getCheckedOption() -> RadioButtonValue? {
        guard let selectedIndex = getCheckedOptionIndex() else {
            return nil
        }
        return optionHolders[selectedIndex].getValue(index: selectedIndex)
    }
    
    private func getCheckedOptionIndex() -> Int? {
        return optionHolders.firstIndex(where: {$0.isChecked})
    }
    
    public func removeSelectedValue() {
        descriptor.selectedOption = nil
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        self.vanguard = vanguard
        validationCase = vanguard.registerValueComponent(
            withName: key, rules: descriptor.rules)
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
            error = errorMessage
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
        
        optionHolders.forEach { holder in
            holder.applyStyle(style: style)
        }
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
    }
}

extension RadioButtonsComponent: OptionHolderDelegate {
    func optionHolderDidTapOnSupplementaryView(view: UIView) {
        checkAction(onView: view)
    }
}

extension RadioButtonsComponent: TextFieldOptionHolderDelegate {
    func textFieldOptionHolder(_ holder: TextFieldOptionHolder, textFieldDidChangeEditing textField: OutlinedTextField) {
        checkAction(onView: holder.supplementaryView)
    }
}
