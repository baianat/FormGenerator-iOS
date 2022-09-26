//
//  PickerComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard

public class PickerComponent: BaseComponent<PickerFieldDescriptor>, FormComponentProtocol {
    public var textField: UIPickerViewTextField
    
    private weak var vanguard: Vanguard?
    private let key = randomString(length: 4)
    public var selectedIndex: Int? {
        didSet {
            guard oldValue != selectedIndex else {
                return
            }
            
            var value: String? = nil
            
            if let index = selectedIndex, index < descriptor.values.count {
                value = descriptor.values[index]
                
            }
            textField.text = value
            vanguard?.validateValue(value: value, withName: key)
        }
    }
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: PickerFieldDescriptor, textField: UIPickerViewTextField) {
        self.textField = textField
        super.init(descriptor: descriptor)
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        return buildComponentView(foundationView: textField, innerSpacing: alignments.componentInnerSpacing)
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        self.vanguard = vanguard
        validationCase = vanguard.registerValueComponent(withName: key, rules: descriptor.rules)
    }
    
    public func updateSelectedValue() {
        guard let index = selectedIndex, index < descriptor.values.count else {
            return
        }
        descriptor.selectedIndex = index
        descriptor.selectedValue = descriptor.values[index]
    }
    
    public func removeSelectedValue() {
        descriptor.selectedIndex = nil
        descriptor.selectedValue = nil
    }
    
    public func applyDefaultValues() {
        selectedIndex = descriptor.selectedIndex
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? String else {
            return false
        }
        return component == key
    }
    
    func notifyDelegateSelectedIndexChanged(selectedIndex: Int) {
        let value = descriptor.values[selectedIndex]
        descriptor.delegate?.pickerFieldDescriptor(
            descriptor,
            didSelectItemAt: selectedIndex,
            selectedValue: value)
    }
}

public class PickerViewComponent: PickerComponent {
    public let pickerView = UIPickerView()
    
    public override init(descriptor: PickerFieldDescriptor, textField: UIPickerViewTextField) {
        super.init(descriptor: descriptor, textField: textField)
        textField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

extension PickerViewComponent: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return descriptor.values.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return descriptor.values[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
        self.notifyDelegateSelectedIndexChanged(selectedIndex: row)
    }
}

public class PickerAlertComponent: PickerComponent {
    public override init(descriptor: PickerFieldDescriptor, textField: UIPickerViewTextField) {
        super.init(descriptor: descriptor, textField: textField)
        textField.pickerDelegate = self
    }
}

extension PickerAlertComponent: PickerTextFieldDelegate {
    public func pickerTextFieldDidTapPick(_ pickerTextField: UIPickerViewTextField) {
        guard !descriptor.values.isEmpty else {
            
            getRootController()?.showAlert(message: Localize.thereAreNoValuesToSelectFrom()) { [weak self] in
                self?.setValidBorderColor()
            }
            return
        }
        getRootController()?.presentValuesPicker(
            title: descriptor.alertTitle ?? "",
            message: nil,
            values: descriptor.values,
            initialSelectionIndex: selectedIndex ?? 0,
            dismissAction: { [weak self] in
                self?.setValidBorderColor()
            },
            submitAction: { [weak self] selectedIndex in
                guard let self = self else { return }
                self.selectedIndex = selectedIndex
                self.notifyDelegateSelectedIndexChanged(selectedIndex: selectedIndex)
                self.setValidBorderColor()
            }
        )
    }
}
