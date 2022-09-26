//
//  ParagraphComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 25/03/2021.
//

import UIKit
import Vanguard

public class ParagraphComponent: UITextViewDelegateWrapper, FormComponentProtocol {
    
    public var textView: UITextView
    public let descriptor: ParagraphDescriptor
    
    public var titleLabel: FormLabel?
    public var errorLabel: UILabel?
    public var placeholderLabel: UILabel?
    
    private lazy var style = FormStyle()
    private var heightConstraint: NSLayoutConstraint?
    
    private var minHeight: CGFloat = 54
    private var maxHeight: CGFloat = .infinity
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: ParagraphDescriptor, textView: UITextView) {
        self.textView = textView
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let innerStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        //TitleLabel
        if let title = descriptor.label {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            innerStackView.addArrangedSubview(titleLabel!)
        }
        //Component
        innerStackView.addArrangedSubview(textView)
        //Error Label
        errorLabel = ViewUtils.createErrorLabel()
        innerStackView.addArrangedSubview(errorLabel!)
        
        switch descriptor.height {
        case .fixed(let height):
            heightConstraint = textView.heightAnchor.constraint(equalToConstant: height)
            heightConstraint?.isActive = true
            
        case .flexible(let minHeight, let maxHeight):
            self.minHeight = minHeight
            self.maxHeight = maxHeight
            heightConstraint = textView.heightAnchor.constraint(equalToConstant: minHeight)
            heightConstraint?.isActive = true
            setupDelegateWrapper()
        }
        
        return innerStackView
    }
    
    private func setupDelegateWrapper() {
        wrappedDelegate = textView.delegate
        textView.delegate = self
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func updateSelectedValue() {
        descriptor.selectedValue = textView.text
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValue = nil
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        validationCase = vanguard.validate(textView: textView, byRules: descriptor.rules)
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? UITextView else {
            return false
        }
        return component === textView
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
        
        textView.setStrokeColor(color: style.failureColor, width: style.textFieldBorderWidth)
    }
    
    public func removeErrorState() {
        errorLabel?.isHidden = true
        errorLabel?.text = nil
        
        setValidBorderColor()
    }
    
    public func getComponentOrigin() -> CGPoint {
        return titleLabel?.getOriginRelativeToSupremeView() ?? .zero
    }
    
    public func applyDefaultValues() {
        textView.text = descriptor.selectedValue
        updatePlaceholderLabelVisibility()
    }
    
    private func setValidBorderColor() {
        let borderColor: UIColor = textView.isFirstResponder == true ? style.activeBorderColor : style.inactiveBorderColor
        textView.setStrokeColor(color: borderColor, width: style.textFieldBorderWidth)
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
        
        textView.font = style.textFieldFont
        textView.textColor = style.textColor
        
        textView.setCornerRadius(value: style.textFieldCornerRadius)
        
        setValidBorderColor()
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
        editingStylizer.setupTextView(textView: textView)
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
        if configuration.showPlaceholders {
            placeholderLabel = UILabel()
            placeholderLabel?.font = .systemFont(ofSize: 17)
            placeholderLabel?.textColor = .lightGray
            placeholderLabel?.text = getComponentLabel()
            textView.addSubview(placeholderLabel!)
            
            placeholderLabel?.translatesAutoresizingMaskIntoConstraints = false
            
            placeholderLabel?.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
            placeholderLabel?.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
            
            updatePlaceholderLabelVisibility()
        }
    }
}

extension ParagraphComponent {
    public override func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderLabelVisibility()
        refreshTextViewHeight()
        descriptor.delegate?.paragraphDescriptor(descriptor, textDidChange: textView.text)
        super.textViewDidChange(textView)
    }
    
    private func updatePlaceholderLabelVisibility() {
        placeholderLabel?.isHidden = textView.text.isEmpty == false
    }
    
    func refreshTextViewHeight() {
        let contentHeight = textView.contentSize.height + 8
        let maxH = max(minHeight, contentHeight)
        let textViewHeight = min(maxH, maxHeight)
        heightConstraint?.constant = textViewHeight
    }
}
