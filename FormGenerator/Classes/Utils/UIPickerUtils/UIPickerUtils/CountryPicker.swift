//
//  CountryPicker.swift
//  UIPickerUtils
//
//  Created by Omar on 10/6/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

extension UIViewController {
    typealias CountryCode = String
    typealias CountryName = String
    
    func presentCountryPicker(dismissAction:(() -> Void)? = nil,
                              submitAction: ((CountryName, CountryCode) -> Void)? = nil){

        let alert = UIAlertController(style: .actionSheet, message: selectCountryText())
        
        alert.addLocalePicker(type: .country) { info in
            if let countryName = info?.country,
                let countryCode = info?.code {
                submitAction?(countryName, countryCode)
            }
        }
        alert.addAction(title: cancelText(), style: .cancel, isEnabled: true) { (_) in
            dismissAction?()
        }
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX,
                                                                 y: self.view.bounds.midY,
                                                                 width: 0,
                                                                 height: 0)
        alert.show()
    }
    
}
