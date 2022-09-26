//
//  EditingStylizer.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 12/21/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

public protocol EditingStylizerDelegate: class {
    func didBeginEditing(onField field: UITextField)
    
    func didEndEditing(onField field: UITextField)
}

public class EditingStylizer: NSObject {
    
    public weak var delegate: EditingStylizerDelegate?
    private var textViewStylizerControllers: [TextViewStylizerController] = []
    private lazy var style = FormStyle()
    
    public override init() {}
    
    public func setupTextFields(textFields: [UITextField]) {
        textFields.forEach { [weak self] (textField) in
            self?.setupTextField(textField: textField)
        }
    }
    
    public func setupTextField(textField: UITextField) {
        textField.addTarget(self, action: #selector(styleForBeginEditing(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(styleForEndEditing(_:)), for: .editingDidEnd)
    }
    
    public func setupTextViews(textViews: [UITextView]) {
        for textView in textViews {
            setupTextView(textView: textView)
        }
    }
    
    public func setupTextView(textView: UITextView) {
        let controller = TextViewStylizerController()
        controller.setupTextView(textView: textView, style: style)
        textViewStylizerControllers.append(controller)
    }
    
    public func applyStyle(style: FormStyle) {
        self.style = style
    }
    
    @objc func styleForBeginEditing(_ sender: UITextField) {
        styleForEditing(view: sender)
        delegate?.didBeginEditing(onField: sender)
    }
    
    @objc func styleForEndEditing(_ sender: UITextField) {
        styleForNonEditing(view: sender)
        delegate?.didEndEditing(onField: sender)
    }
    
    private func styleForEditing(view: UIView) {
        view.setStrokeColor(color: style.activeBorderColor, width: style.textFieldBorderWidth)
        view.setCornerRadius(value: style.textFieldCornerRadius)
    }
    
    private func styleForNonEditing(view: UIView) {
        view.setStrokeColor(color: style.inactiveBorderColor, width: style.textFieldBorderWidth)
        view.setCornerRadius(value: style.textFieldCornerRadius)
    }
}

private class TextViewStylizerController: UITextViewDelegateWrapper {
    lazy var style = FormStyle()
    
    func setupTextView(textView: UITextView, style: FormStyle) {
        self.style = style
        wrappedDelegate = textView.delegate
        textView.delegate = self
    }
    
    private func styleForEditing(view: UIView) {
        view.setStrokeColor(color: style.activeBorderColor, width: style.textFieldBorderWidth)
        view.setCornerRadius(value: style.textFieldCornerRadius)
    }
    
    private func styleForNonEditing(view: UIView) {
        view.setStrokeColor(color: style.inactiveBorderColor, width: style.textFieldBorderWidth)
        view.setCornerRadius(value: style.textFieldCornerRadius)
    }
}

extension TextViewStylizerController {
    public override func textViewDidEndEditing(_ textView: UITextView) {
        styleForNonEditing(view: textView)
        super.textViewDidEndEditing(textView)
    }
    
    public override func textViewDidBeginEditing(_ textView: UITextView) {
        styleForEditing(view: textView)
        super.textViewDidEndEditing(textView)
    }
}
