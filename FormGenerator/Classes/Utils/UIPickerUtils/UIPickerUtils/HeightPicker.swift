//
//  HeightPicker.swift
//  PickersUtils
//
//  Created by Omar on 10/1/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit
private let metersValues = Array(0...2).map({String($0)})
private let centimetersValues = Array(1...99).map({String($0)})

public extension UIViewController {
    
    public func presentHeightPicker(initialHeight: Height,
                                    dismissAction:(() -> Void)? = nil,
                                    submitAction: ((Height) -> Void)? = nil) {
        
        func titleText() -> String {
            return langIsEnglish() ? "Select Height" : "إختر الطول"
        }
        
        var height = initialHeight
        
        let alert = UIAlertController(style: .actionSheet, title: titleText(), message: initialHeight.prettyText())
        
        let pickerViewValues = pickerValues()
        
        alert.addPickerView(values: pickerViewValues, initialSelection: initialSelectedIndices(for: initialHeight)) { _, _, index, values in
            
            height = self.adjustedHeight(height, for: index, values: values)
            alert.set(message: height.prettyText(), font: UIFont.systemFont(ofSize: 13), color: .black)
        }
        alert.addAction(UIAlertAction(title: doneText(), style: .default, handler: { (_) in
            submitAction?(height)
        }))
        alert.addAction(title: cancelText(), style: .cancel, isEnabled: true) { (_) in
            dismissAction?()
        }
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        alert.show()
    }
    
    private func pickerValues() -> [[String]] {
        if langIsEnglish() {
            return [metersValues, [metersText()], centimetersValues, [centimeterText()]]
        } else {
            return [[centimeterText()], centimetersValues, [metersText()], metersValues]
        }
    }
    
    private func adjustedHeight(_ previousHeight: Height,
                                for index: PickerViewViewController.Index,
                                values: [[String]]) -> Height {
        var height = previousHeight
        if langIsEnglish() {
            if index.column == 0 {
                height.meter = Int(values[0][index.row]) ?? 0
            }
            if index.column == 2 {
                height.centiMeter = Int(values[2][index.row]) ?? 0
            }
        } else {
            if index.column == 3 {
                height.meter = Int(values[3][index.row]) ?? 0
            }
            if index.column == 1 {
                height.centiMeter = Int(values[1][index.row]) ?? 0
            }
        }
        return height
    }
    
    private func initialSelectedIndices(for initialHeight: Height) -> [PickerViewViewController.Index] {
        
        let indexOfMeterHeight = String(initialHeight.meter)
        let indexOfCMHeight = String(initialHeight.centiMeter)
        let cmIndex = (centimetersValues.firstIndex(where: {$0 == indexOfCMHeight}) ?? 1)
        let mIndex = metersValues.firstIndex(where: {$0 == indexOfMeterHeight}) ?? 80
        
        if langIsEnglish() {
            return [(column : 0, row : mIndex), (column : 2, row:cmIndex) ]
        } else {
            return [(column : 3, row : mIndex), (column : 1, row:cmIndex) ]
        }
        
    }
}

public struct Height {
    public var meter: Int
    public var centiMeter: Int
    
    public init(meter: Int, centiMeter: Int) {
        self.meter = meter
        self.centiMeter = centiMeter
    }
    
    //    public init(centiMeters: Int) {
    //        self.meter = centiMeters / 1000
    //        self.centiMeter = centiMeters % 1000
    //    }
    
//    public static func create(fromCentiMeters centiMeters: Double) -> Height {
//        let meter = centiMeters / 1000
//        let centiMeter = centiMeters.truncatingRemainder(dividingBy: 10000)
//        return Height(meter: Int(meter), centiMeter: Int(centiMeter))
//    }
    
    public func prettyText() -> String {
        return "\(meter) \(metersText()) \(centiMeter) \(centimeterText())"
    }
    
    public func prettyMeterText() -> String {
        return "\(meter).\(centiMeter/100) \(metersText())"
    }
    public func heightInCentimeter() -> Double{
        return Double((meter*100)+centiMeter)
    }
}
