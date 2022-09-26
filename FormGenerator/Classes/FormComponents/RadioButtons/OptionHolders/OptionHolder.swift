//
//  OptionHolder.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 13/09/2021.
//

import UIKit
import M13Checkbox

protocol OptionHolderDelegate: AnyObject {
    func optionHolderDidTapOnSupplementaryView(view: UIView)
}

protocol OptionHolder: AnyObject {
    var checkBox: M13Checkbox { get }
    var isChecked: Bool { get set }
    var supplementaryView: UIView { get }
    var delegate: OptionHolderDelegate? { get set }
    
    func setCheckActionOnSupplementaryView()
    
    func getValue(index: Int) -> RadioButtonValue?
    func applyStyle(style: FormStyle)
}
