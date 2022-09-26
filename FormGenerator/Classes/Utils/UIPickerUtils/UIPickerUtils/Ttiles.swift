//
//  Texts.swift
//  PickersUtils
//
//  Created by Omar on 10/1/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import Foundation

func langIsEnglish() -> Bool {
    let locale = NSLocale.autoupdatingCurrent
    let lang = locale.languageCode
    return lang == "en"
}

func cancelText() -> String {
    return langIsEnglish() ? "Cancel" : "إلغاء"
}

func doneText() -> String {
    return langIsEnglish() ? "Submit" : "تأكيد"
}

func selectCountryText() -> String {
    return langIsEnglish() ? "Select Country" : "اختر دولة"
}
func birthDateText() -> String {
    return langIsEnglish() ? "Birthdate" : "تاريخ الميلاد"
}

func metersText() -> String {
    return langIsEnglish() ? "m" : "م"
}

func centimeterText() -> String {
    return langIsEnglish() ? "cm" : "سم"
}

func kgText() -> String {
    return langIsEnglish() ? "kg" : "كجم"
}

func gText() -> String {
    return langIsEnglish() ? "gm" : "جم"
}
