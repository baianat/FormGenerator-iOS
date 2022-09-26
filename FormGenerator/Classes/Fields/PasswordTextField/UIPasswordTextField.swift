//
//  UIPasswordTextField.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 10/03/2021.
//

import UIKit

public class UIPasswordTextField: OutlinedTextField {
    
    private var visibilityIcon: FormInteractiveImageView!
    private let iconWidth: CGFloat = 24
    private let iconHeight: CGFloat = 20
    
    @IBInspectable public var iconTintColor: UIColor = .gray {
        didSet {
            visibilityIcon.tintImage(withColor: iconTintColor)
        }
    }
    
    public override func setup() {
        super.setup()
        setupView()
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(
//            by: UIEdgeInsets(
//                top: 0,
//                left: FormDefaultAspects.textFieldLeadingPadding + 25,
//                bottom: 0,
//                right: (2 * FormDefaultAspects.textFieldLeadingPadding) + iconWidth
//            )
//        )
        return bounds.inset(by: editingRectInsets)
    }
    
    private func setupView() {
        let height = self.intrinsicContentSize.height
        let rect = CGRect(x: 0, y: 0, width: height, height: height)
        let rightView = UIView(frame: rect)

        let xPoint = (height/2) - (iconWidth/2)
        let yPoint = (height/2) - (iconHeight/2)
        
        visibilityIcon = FormInteractiveImageView(frame: CGRect(x: xPoint, y: yPoint, width: iconWidth, height: iconHeight))
        isSecureTextEntry = true
        setPasswordIcon()
        visibilityIcon.contentMode = .scaleAspectFit
        visibilityIcon.isUserInteractionEnabled = true
        rightView.isUserInteractionEnabled = true
        
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleVisibilityAction)))

        rightView.addSubview(visibilityIcon)
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    @objc func toggleVisibilityAction() {
        self.togglePasswordVisibility()
        self.setPasswordIcon()
    }
    
    private func setPasswordIcon() {
        let icon = isSecureTextEntry ? R.image.showPasswordIcon() : R.image.hidePasswordIcon()
        visibilityIcon.image = icon
        visibilityIcon.tintImage(withColor: iconTintColor)
    }
}

public extension UIPasswordTextField {
    func stylize(textColor: UIColor? = nil,
                 iconTintColor: UIColor? = nil,
                 font: UIFont? = nil,
                 cornerRadius: CGFloat? = nil,
                 borderColor: UIColor? = nil,
                 borderWidth: CGFloat? = nil
    ) {
        
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let iconTintColor = iconTintColor {
            self.iconTintColor = iconTintColor
            visibilityIcon.tintImage(withColor: iconTintColor)
        }
        if let font = font {
            self.font = font
        }
        if let cornerRadius = cornerRadius {
            setCornerRadius(value: cornerRadius)
        }
        
        
        if let borderColor = borderColor {
            setStrokeColor(color: borderColor, width: borderWidth ?? 1)
            self.clipsToBounds = true
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true
        }
    }
}
