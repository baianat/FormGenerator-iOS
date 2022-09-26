//
//  MultipleFieldsComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 31/03/2021.
//

import UIKit
import Vanguard

class FieldHolder {
    let textField: UITextField = OutlinedTextField()
    let errorLabel: UILabel = ViewUtils.createErrorLabel()
}

public class MultipleFieldsComponent: FormComponentProtocol {
    let descriptor: MultipleFieldsDescriptor
    
    let innerVanguard = Vanguard()
    private let key = randomString(length: 4)
    private lazy var alignments = FormAlignments()
    private lazy var style = FormStyle()
    private lazy var configuration = FormConfiguration(showPlaceholders: false)
    
    let fieldsStackView = ViewUtils.createStackView(spacing: 8)
    let titleLabel = ViewUtils.createTitleLabel(title: "")
    let errorLabel = ViewUtils.createErrorLabel()
    let addButton = UIImageView()
    
    var fieldHolders: [FieldHolder] = []
    
    var creationCount = 0
    
    public init(descriptor: MultipleFieldsDescriptor) {
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        self.alignments = alignments
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        fieldsStackView.spacing = alignments.componentInnerSpacing
        
        if let title = getComponentLabel() {
            titleLabel.text = title
            
            let titleStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
            prepareAddButton()
            titleStackView.addArrangedSubview(titleLabel)
            titleStackView.addArrangedSubview(addButton)
            titleStackView.axis = .horizontal
            
            addButton.setContentHuggingPriority(UILayoutPriority(rawValue: 255), for: .horizontal)
            
            stackView.addArrangedSubview(titleStackView)
            
            setupActions()
        }
        
        stackView.addArrangedSubview(fieldsStackView)
        stackView.addArrangedSubview(errorLabel)
        
        createNewTextField()
        
        return stackView
    }
    
    private func prepareAddButton() {
        addButton.image = R.image.iconPlusFilled()
        addButton.contentMode = .scaleAspectFit
        addButton.setHeightEqualToConstant(24)
        addButton.setWidthEqualToConstant(24)
    }
    
    private func setupActions() {
        addButton.isUserInteractionEnabled = true
        titleLabel.isUserInteractionEnabled = true
        
        addButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(addAction)
            )
        )
        
        titleLabel.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(addAction)
            )
        )
    }
    
    @objc func addAction() {
        if fieldHolders.count == descriptor.maxNumberOfItems {
            getRootController()?.showAlert(message: "\(Localize.numberOfItemsCannotBeMoreThan()) \(descriptor.maxNumberOfItems)")
            return
        }
        
        createNewTextField()
    }
    
    private func createNewTextField() {
        if shouldCreateNewField() {
            let fieldHolder = FieldHolder()
            fieldHolders.append(fieldHolder)
            let holderStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
            
            holderStackView.addArrangedSubview(fieldHolder.textField)
            holderStackView.addArrangedSubview(fieldHolder.errorLabel)
            
            fieldsStackView.addArrangedSubview(holderStackView)
            
            fieldHolder.textField.rightViewMode = .always
            fieldHolder.textField.rightView = createRemoveButton()
            if configuration.showPlaceholders {
                fieldHolder.textField.placeholder = descriptor.fieldPlaceholder
            }
            
            showAllRemoveButtons()
            
            innerVanguard.validate(textField: fieldHolder.textField, byRules: descriptor.rules)
            innerVanguard.validateValue(value: fieldHolders.count, withName: key)
            
            descriptor.delegate?.multipleFieldsDescriptor(descriptor, didAddNewField: fieldHolder.textField)
            descriptor.delegate?.multipleFieldsDescriptor(descriptor, didChangeSelectedValues: getSelectedValues())
        }
    }
    
    private func showAllRemoveButtons() {
        for holder in fieldHolders {
            holder.textField.rightViewMode = .always
        }
    }
    
    private func shouldCreateNewField() -> Bool {
        let lastField = fieldHolders.last?.textField
        return lastField == nil || lastField?.text?.isEmpty == false
    }
    
    private func createRemoveButton() -> UIView {
        let height = style.textFieldHeight
        let rect = CGRect(x: 0, y: 0, width: height, height: height)
        let rightView = UIView(frame: rect)

        let iconWidth: CGFloat = 24
        let iconHeight: CGFloat = 24
        
        let xPoint = (height/2) - (iconWidth/2)
        let yPoint = (height/2) - (iconHeight/2)
        
        let removeIconImageView = FormInteractiveImageView(frame: CGRect(x: xPoint, y: yPoint, width: iconWidth, height: iconHeight))
        removeIconImageView.image = R.image.iconCloseAttachment()
        removeIconImageView.contentMode = .scaleAspectFit
        removeIconImageView.isUserInteractionEnabled = true
        rightView.isUserInteractionEnabled = true
        
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFieldAction(_:))))

        rightView.addSubview(removeIconImageView)
        creationCount += 1
        rightView.tag = creationCount
        return rightView
    }
    
    @objc func removeFieldAction(_ gestureRecognizer: UITapGestureRecognizer) {
        if fieldHolders.count == 1 {
            let textField = fieldHolders[0].textField
            textField.text = ""
            textField.rightViewMode = .never
            
        } else {
            if let index = fieldHolders.firstIndex(where: { (holder) -> Bool in
                holder.textField.rightView?.tag == gestureRecognizer.view?.tag
            }) {
                removeField(at: index)
            }
        }
    }
    
    private func removeField(at index: Int) {
        let arrangedView = fieldsStackView.arrangedSubviews[index]
        fieldsStackView.removeArrangedSubview(arrangedView)
        arrangedView.removeFromSuperview()
        fieldHolders.remove(at: index)
        
        rebuildVanguardCases()
        
        descriptor.delegate?.multipleFieldsDescriptorDidRemoveField(descriptor)
        descriptor.delegate?.multipleFieldsDescriptor(descriptor, didChangeSelectedValues: getSelectedValues())
    }
    
    private func rebuildVanguardCases() {
        innerVanguard.removeAllCases()
        for holder in fieldHolders {
            holder.textField.vanguard(validateInContainer: self, byRules: descriptor.rules)
        }
        registerFieldsCountValidation()
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        if !descriptor.selectedValues.isEmpty {
            for index in fieldHolders.indices {
                removeField(at: index)
            }
            
            for value in descriptor.selectedValues {
                createNewTextField()
                fieldHolders.last?.textField.text = value
            }
        }
    }
    
    public func updateSelectedValue() {
        descriptor.selectedValues = getSelectedValues()
    }
    
    private func getSelectedValues() -> [String] {
        return fieldHolders.compactMap({ (holder) -> String? in
            return holder.textField.text?.isEmpty == false ? holder.textField.text : nil
        })
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValues = []
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        vanguard.addValidationCases(
            VanguardWrapperValidationCase(
                component: VanguardWrapperComponent(vanguard: innerVanguard)
            )
        )
        
        registerFieldsCountValidation()
    }
    
    private func registerFieldsCountValidation() {
        innerVanguard.registerValueComponent(
            withName: key,
            rules: [IntValueRule(predicate: { [weak self] (value) -> Bool in
                guard let self = self else { return false }
                return value >= self.descriptor.minNumberOfItems &&
                    value <= self.descriptor.maxNumberOfItems
            })]
        )
        innerVanguard.validateValue(value: fieldHolders.count, withName: key)
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? Vanguard else {
            return false
        }
        
        return component === innerVanguard
    }
    
    public func isValid() -> Bool {
        return innerVanguard.getFormStatus() == .valid
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        let formStatus = innerVanguard.getDetailedFormStatus()
        if !formStatus.isFormValid() {
            for componentStatus in formStatus.components {
                let holder = findHolderWithComponent(component: componentStatus.component.component)
                
                switch componentStatus.result {
                case .invalid(let resultInfo):
                    if holder == nil {
                        errorLabel.isHidden = false
                        errorLabel.text = "\(Localize.numberOfItemsCannotBeLessThan()) \(descriptor.minNumberOfItems)"
                    } else {
                        let error: String?
                        if descriptor.simplifiedErrorMessage != nil {
                            error = descriptor.simplifiedErrorMessage
                        } else {
                            error = resultInfo.errors.joined(separator: ",\n")
                        }
                        
                        holder?.errorLabel.isHidden = shouldHideErrorLabel || (error == nil)
                        holder?.errorLabel.text = error
                        
                        holder?.textField.setStrokeColor(color: style.failureColor, width: style.textFieldBorderWidth)
                    }
                    
                    
                default:
                    if holder == nil {
                        errorLabel.isHidden = true
                        errorLabel.text = nil
                    } else {
                        setValidBorderColor(textField: holder?.textField)
                    }
                    
                }
            }
        }
    }
    
    private func findHolderWithComponent(component: Any?) -> FieldHolder? {
        guard let field = component as? UITextField else {
            return nil
        }
        
        return fieldHolders.first { (holder) -> Bool in
            return holder.textField == field
        }
    }
    
    private func setValidBorderColor(textField: UITextField?) {
        let borderColor: UIColor = textField?.isFirstResponder == true ? style.activeBorderColor : style.inactiveBorderColor
        textField?.setStrokeColor(color: borderColor, width: style.textFieldBorderWidth)
    }
    
    public func removeErrorState() {
        errorLabel.isHidden = true
        errorLabel.text = nil
        
        for holder in fieldHolders {
            holder.errorLabel.isHidden = true
            holder.errorLabel.text = nil
            setValidBorderColor(textField: holder.textField)
        }
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
        
        for holder in fieldHolders {
            holder.errorLabel.font = style.errorLabelFont
            holder.errorLabel.textColor = style.failureColor
            
            holder.textField.font = style.textFieldFont
            holder.textField.textColor = style.textColor
            
            holder.textField.setCornerRadius(value: style.textFieldCornerRadius)
            if let outlinedTextField = holder.textField as? OutlinedTextField {
                outlinedTextField.textFieldHeight = style.textFieldHeight
            } else {
                holder.textField.setHeightEqualToConstant(style.textFieldHeight)
            }
            
            setValidBorderColor(textField: holder.textField)
        }
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        for holder in fieldHolders {
            editingStylizer.setupTextField(textField: holder.textField)
        }
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
        self.configuration = configuration
        if configuration.showPlaceholders {
            for holder in fieldHolders {
                holder.textField.placeholder = descriptor.fieldPlaceholder
            }
        }
    }
}
