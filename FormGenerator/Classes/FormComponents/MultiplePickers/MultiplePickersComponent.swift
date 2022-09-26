//
//  MultiplePickersComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 12/04/2021.
//

import UIKit
import Vanguard

class PickerHolder {
    init(pickerField: UIPickerViewTextField, selectedValueIndex: Int) {
        self.pickerField = pickerField
        self.selectedValueIndex = selectedValueIndex
    }
    
    let pickerField: UIPickerViewTextField
    var selectedValueIndex: Int
}

protocol MultiplePickersComponentCheckDelegate: class {
    func canCreateNewField(at selectedIndex: Int) -> Bool
}

public class MultiplePickersComponent: FormComponentProtocol {
    let descriptor: MultiplePickersDescriptor
    
    private let key = randomString(length: 4)
    private var alignments = FormAlignments()
    private var style = FormStyle()
    
    private weak var vanguard: Vanguard?
    private var validationCase: ValidationCase?
    
    let fieldsStackView = ViewUtils.createStackView(spacing: 8)
    let zeroHeightView = ViewUtils.createZeroHeightFillerView()
    let titleLabel = ViewUtils.createTitleLabel(title: "")
    let errorLabel = ViewUtils.createErrorLabel()
    let addButton = UIButton()
    
    var pickerHolders: [PickerHolder] = []
    
    weak var checkDelegate: MultiplePickersComponentCheckDelegate?
    
    var creationCount = 0
    
    public init(descriptor: MultiplePickersDescriptor) {
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        self.alignments = alignments
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        fieldsStackView.spacing = alignments.componentInnerSpacing
        
        if let title = getComponentLabel() {
            titleLabel.text = title
            stackView.addArrangedSubview(titleLabel)
        }
        
        stackView.addArrangedSubview(fieldsStackView)
        
        addZeroHeightView()
        
        stackView.addArrangedSubview(addButton)
        setupAddButton()
        
        stackView.addArrangedSubview(errorLabel)
        
        setupActions()
        return stackView
    }
    
    private func addZeroHeightView() {
        fieldsStackView.addArrangedSubview(zeroHeightView)
        zeroHeightView.isHidden = false
    }
    
    private func setupAddButton() {
        let decorator = descriptor.decorator
        addButton.backgroundColor = decorator.addButtonColor
        addButton.setTitleColor(decorator.addButtonTitleColor, for: .normal)
        addButton.setTitle(decorator.addButtonTitle, for: .normal)
        addButton.setHeightEqualToConstant(decorator.addButtonHeight)
        
        switch decorator.addButtonFrameStyle {
        case .circle:
            addButton.setCornerRadius(value: decorator.addButtonHeight/2)
            
        case .square(let cornerRadius):
            addButton.setCornerRadius(value: cornerRadius)
        }
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc func addButtonAction(_ sender: UIButton) {
        if pickerHolders.count == descriptor.maxNumberOfPickers && !descriptor.canSelectTheSameItem {
            getRootController()?.showAlert(message: "\(Localize.numberOfItemsCannotBeMoreThan()) \(descriptor.maxNumberOfPickers)")
            return
        }
        
        getRootController()?.presentValuesPicker(
            values: descriptor.values,
            initialSelectionIndex: 0,
            dismissAction: nil,
            submitAction: { [weak self] (index) in
                self?.createNewPickerField(selectedIndex: index)
            }
        )
    }
    
    private func createNewPickerField(selectedIndex: Int) {
        guard shouldCreateNewField(selectedIndex: selectedIndex) else {
            showTwiceSelectionError()
            return
        }
        
        zeroHeightView.isHidden = true
        
        let holder = PickerHolder(
            pickerField: UIPickerViewTextField(),
            selectedValueIndex: selectedIndex
        )
        pickerHolders.append(holder)
        
        let holderStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        holderStackView.axis = .horizontal
        holderStackView.alignment = .center
        holderStackView.setHeightEqualToConstant(style.textFieldHeight)
        
        holder.pickerField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        holder.pickerField.setContentCompressionResistancePriority(.required, for: .horizontal)
        holderStackView.addArrangedSubview(holder.pickerField)
        
        
        let removeButton = createRemoveButton()
        removeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        holder.pickerField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        holderStackView.addArrangedSubview(removeButton)
        
        creationCount += 1
        holder.pickerField.tag = creationCount
        removeButton.tag = creationCount
        
        fieldsStackView.addArrangedSubview(holderStackView)
        
        holder.pickerField.pickerDelegate = self
        holder.pickerField.text = descriptor.values[selectedIndex]
        
        vanguard?.validateValue(value: pickerHolders.count, withName: key)
        applyStyle(style: style)
        
        descriptor.delegate?.multiplePickersDescriptor(descriptor, didChangeSelection: getSelectedIndices(), getSelectedValues())
    }
    
    func shouldCreateNewField(selectedIndex: Int) -> Bool {
        if descriptor.canSelectTheSameItem {
            return true
        }
        
        if checkDelegate?.canCreateNewField(at: selectedIndex) == false {
            return false
        }
        
        let containsTheSameIndex = pickerHolders.contains { (pickerHolder) -> Bool in
            pickerHolder.selectedValueIndex == selectedIndex
        }
        
        return !containsTheSameIndex
    }
    
    private func createRemoveButton() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.isUserInteractionEnabled = true
        
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.centerIn(container: view)
        imageView.image = R.image.iconCloseAttachment()
        imageView.contentMode = .scaleAspectFit
        imageView.heightEqualsWidth()
        
        let height = style.textFieldHeight * 9/10
        imageView.setHeightEqualToConstant(height)
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(removeAction(_:))
            )
        )
        
        return view
    }
    
    @objc func removeAction(_ gestureRecognizer: UITapGestureRecognizer) {
        if let index = pickerHolders.firstIndex(where: { (holder) -> Bool in
            holder.pickerField.tag == gestureRecognizer.view?.tag
        }) {
            removeField(at: index)
        }
    }
    
    func removeField(at index: Int) {
        let arrangedSubview = fieldsStackView.arrangedSubviews[index+1]
        removeArrangedSubviewFromFieldsStack(arrangedSubview)
        
        pickerHolders.remove(at: index)
        
        if pickerHolders.isEmpty {
            zeroHeightView.isHidden = false
        }
        vanguard?.validateValue(value: pickerHolders.count, withName: key)
    }
    
    private func removeArrangedSubviewFromFieldsStack(_ arrangedSubview: UIView) {
        fieldsStackView.removeArrangedSubview(arrangedSubview)
        arrangedSubview.removeFromSuperview()
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        for index in pickerHolders.indices.reversed() {
            removeField(at: index)
        }
        
        for selectedIndex in descriptor.selectedIndices {
            createNewPickerField(selectedIndex: selectedIndex)
        }
    }
    
    public func updateSelectedValue() {
        descriptor.selectedIndices = getSelectedIndices()
        descriptor.selectedValues = getSelectedValues()
    }
    
    private func getSelectedIndices() -> [Int] {
        return pickerHolders.map({$0.selectedValueIndex})
    }
    
    private func getSelectedValues() -> [String] {
        return descriptor.selectedIndices.map({descriptor.values[$0]})
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValues = []
        descriptor.selectedIndices = []
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        self.vanguard = vanguard
        
        validationCase = vanguard.registerValueComponent(
            withName: key,
            rules: [IntValueRule(predicate: { [weak self] (value) -> Bool in
                guard let self = self else { return false }
                return value >= self.descriptor.minRequiredPickers &&
                    value <= self.descriptor.maxNumberOfPickers
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
            error = "\(Localize.numberOfItemsCannotBeLessThan()) \(descriptor.minRequiredPickers)"
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
    }
    
    private func setValidBorderColor(textField: UITextField?) {
        let borderColor: UIColor = textField?.isFirstResponder == true ? style.activeBorderColor : style.inactiveBorderColor
        textField?.setStrokeColor(color: borderColor, width: style.textFieldBorderWidth)
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        for holder in pickerHolders {
            editingStylizer.setupTextField(textField: holder.pickerField)
        }
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
    }
}

extension MultiplePickersComponent: PickerTextFieldDelegate {
    public func pickerTextFieldDidTapPick(_ pickerTextField: UIPickerViewTextField) {
        guard let index = pickerHolders.firstIndex(where: { (holder) -> Bool in
            holder.pickerField.tag == pickerTextField.tag
        }) else {
            return
        }
        
        getRootController()?.presentValuesPicker(
            values: descriptor.values,
            initialSelectionIndex: index,
            dismissAction: nil,
            submitAction: { [weak self, index] (selectedIndex) in
                self?.submitNewValueAction(holderIndex: index, selectedIndex: selectedIndex)
            }
        )
    }
    
    private func submitNewValueAction(holderIndex: Int, selectedIndex: Int) {
        guard shouldCreateNewField(selectedIndex: selectedIndex) else {
            showTwiceSelectionError()
            return
        }
        pickerHolders[holderIndex].selectedValueIndex = selectedIndex
        pickerHolders[holderIndex].pickerField.text = descriptor.values[selectedIndex]
        
        descriptor.delegate?.multiplePickersDescriptor(descriptor, didChangeSelection: getSelectedIndices(), getSelectedValues())
    }
    
    private func showTwiceSelectionError() {
        getRootController()?.showAlert(message: Localize.youCannotSelectTheSameValueTwice())
    }
}
