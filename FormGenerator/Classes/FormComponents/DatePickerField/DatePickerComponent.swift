//
//  DatePickerComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import UIKit
import Vanguard

public class DatePickerComponent: BaseComponent<DatePickerFieldDescriptor>, FormComponentProtocol {
    public var textField: UIPickerViewTextField
    
    private weak var vanguard: Vanguard?
    private let key = randomString(length: 4)
    
    private var selectedDate: Date?
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: DatePickerFieldDescriptor, textField: UIPickerViewTextField) {
        self.textField = textField
        super.init(descriptor: descriptor)
        
        self.textField.pickerDelegate = self
        if let selectedDate = descriptor.selectedValue {
            self.updateSelectedDate(selectedDate: selectedDate)
        }
    }
    
    private func updateSelectedDate(selectedDate: Date) {
        self.selectedDate = selectedDate
        self.vanguard?.validateValue(value: selectedDate, withName: self.key)
        self.textField.text = selectedDate.format_ddMMyyyy()
        self.setValidBorderColor()
        self.descriptor.delegate?.datePickerFieldDescriptor(descriptor, didSelectDate: selectedDate)
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
        vanguard.validateValue(value: selectedDate, withName: key)
    }
    
    public func updateSelectedValue() {
        descriptor.selectedValue = selectedDate
    }
    
    public func removeSelectedValue() {
        descriptor.selectedValue = nil
    }
    
    public func applyDefaultValues() {
        if let selectedDate = descriptor.selectedValue {
            self.updateSelectedDate(selectedDate: selectedDate)
        }
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? String else {
            return false
        }
        return component == key
    }
}

extension DatePickerComponent: PickerTextFieldDelegate {
    public func pickerTextFieldDidTapPick(_ pickerTextField: UIPickerViewTextField) {
        getRootController()?.presentBirthdatePicker(
            initialDate: descriptor.selectedValue,
            maxDate: descriptor.maxDate,
            minDate: descriptor.minDate,
            dismissAction: { [weak self] in
                self?.setValidBorderColor()
            },
            submitAction: { [weak self] selectedDate in
                guard let self = self else { return }
                self.updateSelectedDate(selectedDate: selectedDate)
            }
        )
    }
}
