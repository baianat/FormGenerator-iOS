//
//  HeightPicker.swift
//  PickersUtils
//
//  Created by Omar on 10/1/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit

private let kgValues = Array(1...300).map({String($0)})
private let gmValues = Array(0...9).map({ $0 != 0 ? (String($0)+"00") : "0"})

public extension UIViewController {

    func presentWeightPicker(initialWeight: Weight,
                                    dismissAction:(() -> Void)? = nil,
                                    submitAction: ((Weight) -> Void)? = nil) {

        func titleText() -> String {
            return langIsEnglish() ? "Select Weight" : "إختر الوزن"
        }

        var weight = initialWeight.reduced()

        let alert = UIAlertController(style: .actionSheet, title: titleText(), message: weight.prettyText())

        let pickerViewValues = pickerValues()

        alert.addPickerView(values: pickerViewValues, initialSelection: initialSelectedIndices(for: weight)) { _, _, index, values in
            weight = self.adjustedWeight(weight, for: index, values: values)
            alert.set(message: weight.prettyText(), font: UIFont.systemFont(ofSize: 13), color: .black)
        }
        alert.addAction(UIAlertAction(title: doneText(), style: .default, handler: { (_) in
            submitAction?(weight)
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

    private func pickerValues() -> [[String]] {
        if langIsEnglish() {
            return [kgValues, [kgText()], gmValues, [gText()]]
        } else {
            return [[gText()], gmValues, [kgText()], kgValues]
        }
    }

    private func adjustedWeight(_ previousWeight: Weight,
                                for index: PickerViewViewController.Index,
                                values: [[String]]) -> Weight {

        var weight = previousWeight
        if langIsEnglish() {
            if index.column == 0 {
                weight.kg = Int(values[0][index.row]) ?? 0
            }
            if index.column == 2 {
                weight.gm = Int(values[2][index.row]) ?? 0
            }
        } else {
            if index.column == 3 {
                weight.kg = Int(values[3][index.row]) ?? 0
            }
            if index.column == 1 {
                weight.gm = Int(values[1][index.row]) ?? 0
            }
        }
        return weight
    }

    private func initialSelectedIndices(for initialWeight: Weight) -> [PickerViewViewController.Index] {
        let adjustedGramsOfWeight = (initialWeight.gm / 100) * 100
        let kg = String(initialWeight.kg)
        let gm = String(adjustedGramsOfWeight)
        let kgIndex = (kgValues.firstIndex(where: {$0 == kg}) ?? 1)
        let gIndex = gmValues.firstIndex(where: {$0 == gm}) ?? 80

        if langIsEnglish() {
            return [(column : 0, row : kgIndex), (column : 2, row:gIndex) ]
        } else {
            return [(column : 3, row : kgIndex), (column : 1, row:gIndex) ]
        }

    }
}

public struct Weight {
    public var kg: Int
    public var gm: Int

    public init(kg: Int, gm: Int) {
        self.kg = kg
        self.gm = gm
    }

    public func prettyText() -> String {
        return "\(kg).\(gm/100) \(kgText())"
    }
    
    func reduced() -> Weight {
        let reducedWeightInKg = kg
        let reducedWeightInG = (gm / 100) * 100
        return Weight(kg: reducedWeightInKg, gm: reducedWeightInG)
    }
    public func weightInKilogram() -> Double {
        return Double(kg) + Double(gm) / Double(1000)
    }
}

public extension Double {
    func toWeight() -> Weight {
        let value: Float = Float(self)
        let kilogramValue = Int(value)
        let gramValue = Int((value - Float(kilogramValue)) * 1000)
        return Weight(kg: kilogramValue, gm: gramValue)
    }
    
    func toHeight() -> Height {
        let meter = self / 100
        let centiMeter = self.truncatingRemainder(dividingBy: 100)
        return Height(meter: Int(meter), centiMeter: Int(centiMeter))
    }
}
