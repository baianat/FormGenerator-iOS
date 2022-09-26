//
//  DatePicker.swift
//  UIPickerUtils
//
//  Created by Omar on 10/6/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit


extension UIViewController {
    func presentBirthdatePicker(initialDate: Date? = nil,
                                maxDate: Date? = nil,
                                minDate: Date? = nil,
                                dismissAction: (() -> Void)? = nil,
                                submitAction: ((Date) -> Void)? = nil) {
        let maxDate = maxDate ?? maxBirthDate()
        let minDate = minDate ?? minBirthDate()
        var selectedDate = initialDate ?? defaultBirthDate()
        if selectedDate > maxDate {
            selectedDate = maxDate
        }
        let alert = UIAlertController(style: .actionSheet, title: birthDateText())
        alert.addDatePicker(mode: .date,
                            date: selectedDate,
                            minimumDate: minDate,
                            maximumDate: maxDate) { date in
            selectedDate = date
        }
        
        alert.addAction(UIAlertAction(title: doneText(), style: .default, handler: { (_) in
            submitAction?(selectedDate)
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
    
    private func defaultBirthDate() -> Date {
        let defaultBirthDate = "1995/07/01" // My Birthdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: defaultBirthDate) ?? Date()
    }
    
    private func minBirthDate() -> Date {
        let minDate = "1950/07/01" // My Birthdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: minDate) ?? Date()
    }
    
    private func maxBirthDate() -> Date {
//        let minDate = "1950/07/01" // My Birthdate
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        return dateFormatter.date(from: minDate) ?? Date()
        return Date()
    }
}
