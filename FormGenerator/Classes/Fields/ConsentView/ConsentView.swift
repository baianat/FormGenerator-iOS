//
//  ConsentView.swift
//  Utils
//
//  Created by Omar on 10/7/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit
import M13Checkbox

//swiftlint:disable all
public protocol ConsentViewDelegate {
    func didTapOnLink(link: URL)
}

@IBDesignable public class ConsentView: UIView {

    // MARK: Outlets
    @IBOutlet weak var termsConditionsTextView: UITextView!
    @IBOutlet weak var checkBox: M13Checkbox!
    
    // MARK: Variable
    public var delegate: ConsentViewDelegate?
    public var isChecked: Bool {
        get {
            return checkBox.checkState == .checked
        }
        set {
            if newValue {
                checkBox.checkState = .checked
            } else {
                checkBox.checkState = .unchecked
            }
        }
    }

    // MARK: Setup functions

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    private func setup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        addSubview(view)
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ConsentView", bundle: Bundle(for: ConsentView.self))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}

//swiftlint: disable all
public extension ConsentView {

    func setup(decorator: ConsentDecorator) {
        setupTextView(font: decorator.font, textColor: decorator.textColor, textSlices: decorator.textSlices)
        setupCheckBox(fillColor: decorator.checkBoxFillColor, checkColor: decorator.checkBoxCheckColor)
    }
    
    private func setupTextView(font: UIFont, textColor: UIColor, textSlices: [TextSlice]) {
        let text = NSMutableAttributedString(string: "")
        for slice in textSlices {
            slice.appendIn(attributedString: text)
        }
        
        text.addAttribute(NSAttributedString.Key.font,
                          value: font,
                          range: NSMakeRange(0, text.length))
        
        text.addAttribute(NSAttributedString.Key.foregroundColor,
                          value: textColor,
                          range: NSMakeRange(0, text.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.alignment = NSTextAlignment.left
        text.addAttribute(NSAttributedString.Key.paragraphStyle,
                          value: paragraphStyle,
                          range: NSMakeRange(0, text.length))
        
        termsConditionsTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: font]
        
        termsConditionsTextView.attributedText = text
        
        termsConditionsTextView.isEditable = false
        termsConditionsTextView.isSelectable = true
        termsConditionsTextView.delegate = self
    }
    
    private func setupCheckBox(fillColor: UIColor, checkColor: UIColor) {
        checkBox.stateChangeAnimation = .bounce(.fill)
        checkBox.tintColor = fillColor
        checkBox.secondaryTintColor = fillColor
        checkBox.secondaryCheckmarkTintColor = checkColor
        checkBox.boxLineWidth = 2
        checkBox.checkmarkLineWidth = 2
    }
    
}
extension NSMutableAttributedString {
    func appendSpace() {
        append(NSAttributedString.init(string: " "))
    }
    
    func appendNormalText(text: String) {
        append(NSAttributedString.init(string: text))
    }
    
    func appendLinkText(text: String, link: String) {
        let slice = NSMutableAttributedString(string: text)
        
        slice.addAttribute(NSAttributedString.Key.link,
                                  value: link,
                                  range: NSMakeRange(0, slice.length))
        slice.addAttribute(NSAttributedString.Key.underlineStyle,
                                  value: 1,
                                  range: NSMakeRange(0, slice.length))
        
        append(slice)
    }
}
extension ConsentView: UITextViewDelegate {
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {

        delegate?.didTapOnLink(link: URL)
        return false
    }
}

