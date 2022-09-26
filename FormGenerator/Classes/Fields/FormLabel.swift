//
//  FormLabel.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 14/04/2021.
//

import Foundation

public class FormLabel: UILabel {
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            sizeToFit()
        }
    }
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
}
