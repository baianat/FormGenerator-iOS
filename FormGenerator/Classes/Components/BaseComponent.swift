//
//  BaseComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 23/03/2021.
//

import UIKit

public class BaseComponent<D: Descriptor>: NSObject,
                                           FormComponentErrorProtocol,
                                           FormConfigurationProtocol {
    public var errorLabel: UILabel?
    public var titleLabel: FormLabel?
    public var descriptor: D
    
    public lazy var style = FormStyle()
    
    weak var foundationView: UITextField?
    
    public init(descriptor: D) {
        self.descriptor = descriptor
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        let error: String?
        if descriptor.simplifiedErrorMessage != nil {
            error = descriptor.simplifiedErrorMessage
        } else {
            error = errorMessage
        }
        
        errorLabel?.isHidden = shouldHideErrorLabel || (error == nil)
        errorLabel?.text = error
        
        foundationView?.setStrokeColor(color: style.failureColor, width: style.textFieldBorderWidth)
    }
    
    public func removeErrorState() {
        errorLabel?.isHidden = true
        errorLabel?.text = nil
        
        setValidBorderColor()
    }
    
    public func getComponentOrigin() -> CGPoint {
        return titleLabel?.getOriginRelativeToSupremeView() ?? .zero
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
        if configuration.showPlaceholders {
            foundationView?.placeholder = descriptor.label
        }
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
        
        errorLabel?.font = style.errorLabelFont
        errorLabel?.textColor = style.failureColor
        
        foundationView?.font = style.textFieldFont
        foundationView?.textColor = style.textColor
        
        foundationView?.setCornerRadius(value: style.textFieldCornerRadius)
        foundationView?.setHeightEqualToConstant(style.textFieldHeight)
        
        setValidBorderColor()
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        if let field = foundationView {
            editingStylizer.setupTextField(textField: field)
        }
    }
    
    func setValidBorderColor() {
        let borderColor: UIColor = foundationView?.isFirstResponder == true ? style.activeBorderColor : style.inactiveBorderColor
        foundationView?.setStrokeColor(color: borderColor, width: style.textFieldBorderWidth)
    }
    
    public func buildComponentView(foundationView: UITextField, innerSpacing: CGFloat) -> UIView {
        self.foundationView = foundationView
        let innerStackView = ViewUtils.createStackView(spacing: innerSpacing)
        
        //TitleLabel
        if let title = descriptor.label {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            innerStackView.addArrangedSubview(titleLabel!)
        }
        //Component
        innerStackView.addArrangedSubview(foundationView)
        //Error Label
        errorLabel = ViewUtils.createErrorLabel()
        innerStackView.addArrangedSubview(errorLabel!)
        
        return innerStackView
    }
}
