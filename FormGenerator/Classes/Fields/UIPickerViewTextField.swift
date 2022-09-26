//
//  UIPickerViewTextField.swift
//  AbjadUtils
//
//  Created by Ahmed Tarek on 1/18/21.
//

import UIKit

public protocol PickerTextFieldDelegate: AnyObject {
    func pickerTextFieldDidTapPick(_ pickerTextField: UIPickerViewTextField)
}

public enum PickerType {
    case alert
    case pickerView
}

public class UIPickerViewTextField: OutlinedTextField {
    public var pickerType: PickerType = .alert
    
    public weak var pickerDelegate: PickerTextFieldDelegate?
    
    private let iconWidth: CGFloat = 14
    private let iconHeight: CGFloat = 14
    
    public override func setup() {
        super.setup()
        let height = self.intrinsicContentSize.height
        let rect = CGRect(x: 0, y: 0, width: height, height: height)
        let rightView = UIView(frame: rect)

        let xPoint = (height/2) - (iconWidth/2)
        let yPoint = (height/2) - (iconHeight/2)
        
        let downArrow = UIImageView(frame: CGRect(x: xPoint, y: yPoint, width: iconWidth, height: iconHeight))
        downArrow.image = R.image.downArrow()
        downArrow.contentMode = .scaleAspectFit
        downArrow.isUserInteractionEnabled = true
        rightView.isUserInteractionEnabled = true
        
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickerAction)))

        rightView.addSubview(downArrow)

        self.rightView = rightView
        self.rightViewMode = .always
        
        addTarget(self, action: #selector(beginEditingAction), for: .editingDidBegin)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(
            by: UIEdgeInsets(
                top: 0,
                left: FormDefaultAspects.textFieldLeadingPadding,
                bottom: 0,
                right: (2 * FormDefaultAspects.textFieldLeadingPadding) + iconWidth
            )
        )
    }
    
    @objc func pickerAction() {
        becomeFirstResponder()
    }
    
    @objc func beginEditingAction() {
        if pickerType == .alert {
            tapPickAction()
        }
    }
    
    private func tapPickAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            self.endEditing(true)
            self.pickerDelegate?.pickerTextFieldDidTapPick(self)
        }
    }
}

@objc
extension UIViewController {
    func endEditing() {
        view.endEditing(true)
        view.resignFirstResponder()
    }
}
