//
//  NormalOptionHolder.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 14/09/2021.
//

import Foundation
import M13Checkbox

class NormalOptionHolder: OptionHolder {
    
    let checkBoxView: M13Checkbox
    let descriptionView: UILabel
    let decorator: RadioOptionLabelDecorator
    
    init(
        checkBox: M13Checkbox,
        descriptionView: UILabel,
        decorator: RadioOptionLabelDecorator
    ) {
        self.checkBoxView = checkBox
        self.descriptionView = descriptionView
        self.decorator = decorator
        
        self.applyDecorator()
    }
    
    func applyDecorator() {
        descriptionView.font = decorator.font
        descriptionView.textColor = decorator.textColor
    }
    
    var checkBox: M13Checkbox {
        return checkBoxView
    }
    
    var isChecked: Bool {
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
    
    var supplementaryView: UIView {
        return descriptionView
    }
    
    weak var delegate: OptionHolderDelegate?
    
    func setCheckActionOnSupplementaryView() {
        descriptionView.isUserInteractionEnabled = true
        descriptionView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(descriptionTapGestureHandler)
            )
        )
    }
    
    @objc func descriptionTapGestureHandler() {
        delegate?.optionHolderDidTapOnSupplementaryView(view: descriptionView)
    }
    
    func getValue(index: Int) -> RadioButtonValue? {
        return .defaultSelection(index: index)
    }
    
    func applyStyle(style: FormStyle) {
    }
}
