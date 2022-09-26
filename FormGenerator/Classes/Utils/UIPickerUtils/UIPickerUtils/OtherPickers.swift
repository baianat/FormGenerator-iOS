//
//  OtherPickers.swift
//  UIPickerUtils
//
//  Created by Omar on 10/6/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentYesNoPicker(title: String? = nil,
                            message: String? = nil,
                            initialSelection: Bool = true,
                            dismissAction:(() -> Void)? = nil,
                            submitAction: ((Bool) -> Void)? = nil) {
        
        func pickerValues() -> [[String]] {
            if langIsEnglish() {
                return [["Yes", "No"]]
            } else {
                return [["نعم", "لا"]]
            }
        }
        
        func initialSelectedIndices(for initialSelection: Bool) -> [PickerViewViewController.Index] {

            if langIsEnglish() {
                return initialSelection ? [(column : 0, row : 0)] : [(column : 0, row : 1)]
            } else {
                return initialSelection ? [(column : 0, row : 0)] : [(column : 0, row : 1)]
            }

        }
        
        var selection = initialSelection
        let alert = UIAlertController(style: .actionSheet, title: title, message: message)

        let pickerViewValues = pickerValues()

        alert.addPickerView(values: pickerViewValues,
                            initialSelection: initialSelectedIndices(for: initialSelection)) { _, _, index,_ in
            selection = index.row == 0
        }
        alert.addAction(UIAlertAction(title: doneText(), style: .default, handler: { (_) in
            submitAction?(selection)
        }))
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

extension UIViewController {
    
    func presentValuesPicker(title: String? = nil,
                             message: String? = nil,
                             values: [String],
                             initialSelectionIndex: Int = 0,
                             dismissAction:(() -> Void)? = nil,
                             submitAction: ((Int) -> Void)? = nil) {
        
        let alert = createPickerAlert(title: title, message: message, values: values, initialSelectionIndex: initialSelectionIndex, dismissAction: dismissAction, submitAction: submitAction)
        alert.show()
    }
    
    func createPickerAlert(
        title: String? = nil,
        message: String? = nil,
        values: [String],
        initialSelectionIndex: Int = 0,
        dismissAction:(() -> Void)? = nil,
        submitAction: ((Int) -> Void)? = nil) -> UIAlertController {
        
        var selection = initialSelectionIndex
        let alert = UIAlertController(style: .actionSheet, title: title, message: message)

        let pickerViewValues = [values]
        let initialSelection = [(column : 0, row : initialSelectionIndex)]
        alert.addPickerView(values: pickerViewValues,
                            initialSelection: initialSelection) { _, _, index, _ in
            selection = index.row
        }
        
        alert.addAction(UIAlertAction(title: doneText(), style: .default, handler: { (_) in
            submitAction?(selection)
        }))
        alert.addAction(title: cancelText(), style: .cancel, isEnabled: true) { (_) in
            dismissAction?()
        }
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX,
                                                                 y: self.view.bounds.midY,
                                                                 width: 0,
                                                                 height: 0)
        
        return alert
    }
    
}
