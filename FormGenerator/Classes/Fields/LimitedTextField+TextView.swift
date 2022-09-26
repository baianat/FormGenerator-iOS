//
//  LimitedTextField.swift
//  Utils
//
//  Created by Omar on 10/14/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

@IBDesignable open class FormLimitedTextField: UITextField {
    
    @IBInspectable public var maxLength: Int = 36
    
    public override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open func setup() {
        delegate = self
    }
}

extension FormLimitedTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let rawString = string
        let whiteSpaceRange = rawString.rangeOfCharacter(from: .whitespaces)
        
        if textField.text?.count == 0 {
            
            if  whiteSpaceRange  != nil
            {
                return false
            }
            else {
                return true
            }
        }
        else {
            if ((textField.text?.count)! > 0 && textField.text?.last  == " " && whiteSpaceRange != nil) {
                return false
            }
            else {
                let currentTextLength = textField.text?.count ?? 0
                return (currentTextLength - range.length + string.count) <= maxLength
            }
        }
    }
}

@IBDesignable open class FormLimitedTextView: UITextView {
    
    @IBInspectable public var maxLength: Int	= 400
    
    public override init(
        frame: CGRect = CGRect.zero,
        textContainer: NSTextContainer? = nil
    ) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open func setup() {
        delegate = self
    }
}

extension FormLimitedTextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text?.count == 0 {
            
            let rawString = text
            let range = rawString.rangeOfCharacter(from: .whitespaces)
            
            if ((textView.text?.count)! == 0 && range  != nil) {
                return false
            }
            else {
                return true
            }
        }
        else {
            let currentTextLength = textView.text?.count ?? 0
            return (currentTextLength - range.length + text.count) <= maxLength
        }
    }
}
