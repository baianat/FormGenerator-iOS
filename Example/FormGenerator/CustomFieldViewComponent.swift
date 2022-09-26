//
//  CustomFieldView.swift
//  FormGeneratorExample
//
//  Created by Ahmed Tarek on 01/04/2021.
//

import UIKit
import FormGenerator

class CustomFieldViewComponent: CustomFormComponent {
    override func buildComponent(alignments: FormAlignments) -> UIView {
        let view = UIView()
        view.height(100)
        view.backgroundColor = .magenta
        return view
    }
}
