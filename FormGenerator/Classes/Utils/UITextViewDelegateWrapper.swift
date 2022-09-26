//
//  UITextViewDelegateWrapper.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 25/03/2021.
//

import UIKit

public class UITextViewDelegateWrapper: NSObject {
    public init(wrappedDelegate: UITextViewDelegate? = nil, newDelegate: UITextViewDelegate? = nil) {
        self.wrappedDelegate = wrappedDelegate
        self.newDelegate = newDelegate
    }
    
    weak var wrappedDelegate: UITextViewDelegate?
    weak var newDelegate: UITextViewDelegate?
}

extension UITextViewDelegateWrapper: UITextViewDelegate {
    public func textViewDidEndEditing(_ textView: UITextView) {
        wrappedDelegate?.textViewDidEndEditing?(textView)
        newDelegate?.textViewDidEndEditing?(textView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        wrappedDelegate?.textViewDidBeginEditing?(textView)
        newDelegate?.textViewDidBeginEditing?(textView)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        wrappedDelegate?.textViewDidChange?(textView)
        newDelegate?.textViewDidChange?(textView)
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        wrappedDelegate?.textViewDidChangeSelection?(textView)
        newDelegate?.textViewDidChangeSelection?(textView)
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return wrappedDelegate?.textViewShouldEndEditing?(textView) ??
            newDelegate?.textViewShouldEndEditing?(textView) ??
            true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return wrappedDelegate?.textViewShouldBeginEditing?(textView) ??
            newDelegate?.textViewShouldBeginEditing?(textView) ??
            true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return wrappedDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ??
            newDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ??
            true
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return wrappedDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ??
            newDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ??
            true
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return wrappedDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ??
            newDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ??
            true
    }
}
