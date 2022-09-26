//
//  CountryPickerFieldComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 25/04/2021.
//

import UIKit
import Vanguard
import FlagPhoneNumber

public class CountryPickerFieldComponent:
    BaseComponent<CountryPickerFieldDescriptor>,
    FormComponentProtocol {
    private var textField: UIPickerViewTextField
    
    private weak var vanguard: Vanguard?
    private let key = randomString(length: 16)
    private var selectedCountry: FormCountry? {
        didSet {
            guard oldValue?.countryCode != selectedCountry?.countryCode else {
                return
            }
            
            textField.text = selectedCountry?.countryName
            vanguard?.validateValue(value: selectedCountry, withName: key)
            
            descriptor.delegate?.countryPickerFieldDescriptor(
                descriptor,
                didSelectCountry: selectedCountry)
        }
    }
    
    var validationCase: ValidationCase?
    
    private var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    public override init(descriptor: CountryPickerFieldDescriptor) {
        self.textField = UIPickerViewTextField()
        super.init(descriptor: descriptor)
        self.textField.pickerDelegate = self
        self.setupCountryViewController()
    }
    
    private func setupCountryViewController() {
        func isLangEnglish() -> Bool {
           let locale = NSLocale.autoupdatingCurrent
           let lang = locale.languageCode
           return lang == "en"
        }
        listController.title = isLangEnglish() ? "Select Country" : "إختر الدولة"
        let repository = FPNCountryRepository()
        switch descriptor.countriesList {
        case .with(let countryCodes):
            repository.setup(with: countryCodes.compactMap({ (code) in
                FPNCountryCode(rawValue: code)
            }))
            
        case .without(let countryCodes):
            repository.setup(without: countryCodes.compactMap({ (code) in
                FPNCountryCode(rawValue: code)
            }))
            
        default:
            break
        }
        listController.setup(repository: repository)
        listController.didSelect = { [weak self] country in
            self?.selectedCountry = FormCountry(
                countryName: country.name,
                countryCode: country.code.rawValue
            )
            self?.setValidBorderColor()
        }
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
        descriptor.selectedCountry = selectedCountry
    }
    
    public func removeSelectedValue() {
        descriptor.selectedCountry = nil
    }
    
    public func applyDefaultValues() {
        selectedCountry = descriptor.selectedCountry
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? String else {
            return false
        }
        return component == key
    }
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
}

extension CountryPickerFieldComponent: PickerTextFieldDelegate {
    public func pickerTextFieldDidTapPick(_ pickerTextField: UIPickerViewTextField) {
        
        let navigationViewController = UINavigationController(rootViewController: listController)
        getRootController()?.present(
            navigationViewController,
            animated: true
        ) { [weak self] in
            self?.setValidBorderColor()
        }
    }
}
