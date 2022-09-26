//
//  OutlinedTextField.swift
//  InstacareUtils
//
//  Created by Omar on 10/6/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

public class OutlinedTextField: FormLimitedTextField {
    
    public var textFieldHeight: CGFloat = FormDefaultAspects.textFieldHeight {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
//    private let iconWidth: CGFloat = 14
//    private let iconHeight: CGFloat = 14
    
    public var editingRectInsets: UIEdgeInsets = UIEdgeInsets(
        top: 0,
        left: FormDefaultAspects.textFieldLeadingPadding,
        bottom: 0,
        right: FormDefaultAspects.textFieldLeadingPadding
    ) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override func setup() {
        super.setup()
        borderStyle = .none
        setStrokeColor(color: .gray, width: FormDefaultAspects.textfieldBorderWidth)
        setCornerRadius(value: FormDefaultAspects.textfieldCornerRadius)
        textColor = .black
    }
    
    func setupIcon(image: UIImage?, iconWidth: CGFloat?) {
        let height = self.intrinsicContentSize.height
        let view = UIView(frame: CGRect(x: 0, y: 0, width: height, height: height))

        let xPoint = (height/2) - ((iconWidth ?? 14)/2)
        let yPoint = (height/2) - ((iconWidth ?? 14)/2)
        
        let imageView = UIImageView(frame: CGRect(x: xPoint, y: yPoint, width: iconWidth ?? 14, height: iconWidth ?? 14))
        imageView.image = image //R.image.descriptorIcon()
        imageView.contentMode = .scaleAspectFit

         view.addSubview(imageView)

        self.leftView = view
        self.leftViewMode = .always
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: editingRectInsets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: editingRectInsets)
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textFieldHeight)
    }
    
    public override func prepareForInterfaceBuilder() {
         invalidateIntrinsicContentSize()
    }

}
