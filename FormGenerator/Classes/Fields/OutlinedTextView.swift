//
//  OutlinedTextView.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 25/03/2021.
//

import UIKit

@IBDesignable public class OutlinedTextView: FormLimitedTextView {
    public override func setup() {
        super.setup()
        self.setCornerRadius(value: FormDefaultAspects.textfieldCornerRadius)
        self.setStrokeColor(color: .gray, width: FormDefaultAspects.textfieldBorderWidth)
        self.textColor = .black
        textContainerInset = UIEdgeInsets(
            top: FormDefaultAspects.textFieldLeadingPadding,
            left: FormDefaultAspects.textFieldLeadingPadding,
            bottom: FormDefaultAspects.textFieldLeadingPadding,
            right: FormDefaultAspects.textFieldLeadingPadding
        )
    }
}
