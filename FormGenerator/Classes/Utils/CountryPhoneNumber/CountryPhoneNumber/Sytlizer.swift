//
//  Sytlizer.swift
//  CountryPhoneNumber
//
//  Created by Omar on 10/5/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import FlagPhoneNumber
import UIKit

extension FPNTextField {
    func stylize(textColor: UIColor? = nil,
                 font: UIFont? = nil,
                 cornerRadius: CGFloat? = nil,
                 borderColor: UIColor? = nil,
                 borderWidth: CGFloat? = nil) {
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let font = font {
            self.font = font
        }
        if let cornerRadius = cornerRadius {
            setCornerRadius(cornerRadius)
        }
        if let borderColor = borderColor {
            self.clipsToBounds = true
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true
        }
        if let borderWidth = borderWidth {
            self.clipsToBounds = true
            self.layer.borderWidth = borderWidth
            self.layer.masksToBounds = true
        }
    }
    
    private func setCornerRadius(_ value:CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
}
