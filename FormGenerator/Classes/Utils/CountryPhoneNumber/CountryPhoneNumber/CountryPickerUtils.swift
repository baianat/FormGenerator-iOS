//
//  CountryPickerUtils.swift
//  Rigow
//
//  Created by Omar on 6/21/20.
//  Copyright © 2020 Omar. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import CoreTelephony

public class CountryPickerHelpers: NSObject  {
    
  private var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    private weak var viewController: UIViewController!
    private weak var textField: FPNTextField!
    
    public static func create(
        textField: FPNTextField,
        in viewController: UIViewController,
        defaultCountryCode: String? = nil) -> CountryPickerHelpers {
        let a = CountryPickerHelpers()
        let countryCode: FPNCountryCode =
            FPNCountryCode(
                rawValue: defaultCountryCode ??
                    CTCarrier().isoCountryCode ??
                    Locale.current.regionCode ??
                    ""
            ) ?? .EG
        
        
        a.bind(with: textField, in: viewController, defaultFlag: countryCode)
        return a
    }
    
    private func bind(
        with textField: FPNTextField,
        in viewController: UIViewController,
        defaultFlag: FPNCountryCode
    ){
        textField.delegate = self
        self.viewController = viewController
        self.textField = textField
        self.textField.displayMode = .list
        self.textField.setFlag(countryCode: defaultFlag)
        self.listController.didSelect = { [weak self] country in
            self?.textField.selectedCountry = country
        }
    }
    
    public func fire(){}

}
extension CountryPickerHelpers:FPNTextFieldDelegate {

    public func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    public func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {

        } else {
            
        }
    }
    
    public func fpnDisplayCountryList() {
        func isLangEnglish() -> Bool {
           let locale = NSLocale.autoupdatingCurrent
           let lang = locale.languageCode
           return lang == "en"
        }
        
        let navigationViewController = UINavigationController(rootViewController: listController)
        FPNCountryRepository()
            
        listController.setup(repository: textField.countryRepository)
        listController.title = isLangEnglish() ? "Select Country" : "إختر الدولة"
        viewController.present(navigationViewController, animated: true, completion: nil)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location <= 20
    }
    
}

