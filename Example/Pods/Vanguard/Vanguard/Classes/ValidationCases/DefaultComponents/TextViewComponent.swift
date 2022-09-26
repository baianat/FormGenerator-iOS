//
//  TextViewComponent.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 12/29/20.
//

import UIKit

public class TextViewComponent: NSObject, VanguardComponent {
    public var delegate: VanguardComponentDelegate?
    weak var textView: UITextView?
    
    public var component: Any? {
        return textView
    }
    
    public init(textView: UITextView) {
        self.textView = textView
    }
    
    public func registerObserver() {
        textView?.textStorage.delegate = self
    }
    
    public func unregisterObserver() {
        textView?.textStorage.delegate = nil
    }
    
    public func getValue() -> Any? {
        return textView?.text ?? ""
    }
    
}

extension TextViewComponent: NSTextStorageDelegate {
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        delegate?.valueDidChange()
    }
}

extension UITextView {
    func vanguardComponent() -> VanguardComponent {
        return TextViewComponent(textView: self)
    }
}

public extension UITextView {
    func vanguard(validateInContainer container: Any, byRules rules: [Rule]) -> ValidationCase? {
        return VanguardUtils.findVanguard(inContainer: container)?
            .validate(textView: self, byRules: rules)
    }
}
