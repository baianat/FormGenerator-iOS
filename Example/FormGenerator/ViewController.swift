//
//  ViewController.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 04/07/2021.
//  Copyright (c) 2021 Ahmed Tarek. All rights reserved.
//

import UIKit
import FormGenerator
import Vanguard

func getValue<T>(_ label: String) -> T {
    let x: Any = ""
    return x as! T
}

struct RegisterModelInput {
    let input: RegisterInput
    
    var profilePicture: ImageItem {
        getValue(#function)
    }
    
    var name: String {
        getValue(#function)
    }
}

class RegisterInput {
    var profilePicture = ProfilePicturePickerDescriptor(
        isRequired: true,
        decorator: ProfilePicturePickerDecorator(
            pickButtonColor: .blue,
            pickButtonSize: 40,
            imageViewSize: 120,
            frameStyle: .square(cornerRadius: 20),
            titleColor: .gray
        ),
        label: "Upload profile picture")
    
    var dualName = HorizontalDualFieldDescriptor(
        first: NameFieldDescriptor(label: "First Name",
                                   decorator: TextFieldDecorator(
                                       showPlaceHolderImage: true)),
        second: NameFieldDescriptor(label: "Last Name",
                                    decorator: TextFieldDecorator(placeHolderImage: nil,
                                                                  showPlaceHolderImage: false,
                                                                  iconSize: 30
                                                                 )
                                   )
    )
    
    var numberOfCopies = RadioButtonsDescriptor(
        axis: .horizontal,
        decorator: RadioButtonDecorator(
            fillColor: .green,
            checkColor: .white,
            labelDecorator: RadioOptionLabelDecorator(
                textColor: .gray
            ),
            textFieldDecorator: RadioOptionTextFieldDecorator(
                textColor: .blue
            )
        ),
        label: "Number of Copies"
    )
    
    var fieldWithPicker = FieldWithPickerDescriptor(
        decorator: .init(
            fieldKeyboardType: .numberPad
        ),
        label: "Field with Picker",
        pickerAlertTitle: "Select Picker Value"
    )
    
    var pickers = MultiplePickersDescriptor(
        canSelectTheSameItem: true,
        decorator: MultiplePickersDecorator(
            addButtonColor: .green, addButtonTitleColor: .red, addButtonTitle: "New Value", addButtonHeight: 80, addButtonFrameStyle: .square(cornerRadius: 8)
        ),
        label: "Pickers"
    )
    
    var country = CountryPickerFieldDescriptor(
        countriesList: .without(countryCodes: ["EG"]),
        label: "Country"
    )
    
    var gender = RadioButtonsDescriptor(
        axis: .horizontal,
        decorator: RadioButtonDecorator(),
        label: "Gender"
    )
    
    var email = EmailFieldDescriptor(
        label: "Email"
        ,
        decorator: TextFieldDecorator(
            showPlaceHolderImage: true)
    )
    
    var phone = PhoneFieldDescriptor(label: "Phone")
    
    var certificates = MultipleItemPickerDescriptor(
        canPickImages: true,
        maxNumberOfItems: 3,
        decorator: MultipleItemPickerDecorator(
            uploadButtonSize: CGSize(width: 20, height: 20),
            borderStyle: .dash(lineWidth: 1, dashSize: 20, gapSize: 20),
            cornerRadius: 20,
            emptyCollectionHeight: 200
        ),
        label: "Certificates"
    )
    
    var idDocument = SingleItemPickerDescriptor(
        decorator: SingleItemPickerDecorator(
            uploadButtonSize: CGSize(width: 40, height: 40),
            docFileIconHeight: 72,
            borderStyle: .dash(lineWidth: 1, dashSize: 3, gapSize: 10),
            cornerRadius: 16),
        label: "Id"
    )
    
    var city = PickerFieldDescriptor.createWithAlertPicker(alertTitle: "Choose City", label: "City")
    
    var birthdate = DatePickerFieldDescriptor(label: "Birth Date")
    
    var password = PasswordFieldDescriptor(
        shouldShowConfirmField: false,
        shouldUsePasswordMeter: true,
        label: "Password",
        confirmLabel: "Confirm Password",
        decorator: TextFieldDecorator(
            showPlaceHolderImage: true)
    )
    
    var custom = CustomDescriptor(customComponent: CustomFieldViewComponent())
    
    var bio = ParagraphDescriptor(label: "Bio", height: .flexible(minHeight: 54, maxHeight: 120))
    
    var privacyAndTerms = ConsentCheckBoxDescriptor(decorator: .dummy, defaultValue: false)
    
    var requirements = MultipleFieldsDescriptor(
        minNumberOfItems: 2,
        maxNumberOfItems: 3,
        label: "Requirements",
        fieldPlaceholder: "Add new requirement",
        rules: []
    )
    
    var primaryAndSecondary = PrimaryAndSecondaryPickersDescriptor(
        numberOfPrimaryFields: 1,
        primaryLabel: "Primary Language",
        secondaryLabel: "Secondary language"
    )
}

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var form = FormGenerator()
    var input = RegisterInput()
    
    var name: String {
        print("\(#function)")
        return "fssdf"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //input.name.simplifiedErrorMessage = "Please enter a valid name"
        input.city.values = ["Port Said", "Damietta", "Cairo"]
        input.pickers.values = ["Port Said", "Damietta", "Cairo"]
        input.primaryAndSecondary.values = ["Port Said", "Damietta", "Cairo"]
        input.fieldWithPicker.pickerValues = ["SAR"]
        input.fieldWithPicker.pickerSelectedIndex = 0
        
        input.numberOfCopies.options = [
            .withTextField(
                placeholder: "Enter number",
                contract: TextFieldContract(
                    rules: [NumericRule()],
                    keyboardType: .numberPad
                )
            ),
            .normal(title: "Unlimited")
        ]
        input.city.delegate = self
        
        form.applyStyle(
            style: FormStyle(
                textFieldFont: UIFont.systemFont(ofSize: 16),
                titleLabelSidePadding: 16,
                inactiveBorderColor: .gray,
                activeBorderColor: .blue,
                textColor: .black,
                textFieldCornerRadius: FormDefaultAspects.textFieldHeight/2
            )
        )
        form.setAlignments(alignments: FormAlignments(sideMargin: 0))
        form.enableRealTimeValidation = true
        form.showErrorLabels = true
        form.showPlaceholders = true
        form.generate(forInput: input, inContainer: containerView)
        updateInputDefaults()
        
    }

    @IBAction func buttonAction(_ sender: Any) {
        form.evaluateInput()
        form.scrollToFirstComponentWithErrorState(in: scrollView)
        
        print("First Name: \(input.dualName.first.selectedValue)")
        print("Last Name: \(input.dualName.second.selectedValue)")
        print("Email: \(input.email.selectedValue)")
        print("City: \(input.city.selectedValue)")
        print("Password: \(input.password.selectedValue)")
        print("PrivacyAndTerms: \(input.privacyAndTerms.selectedValue)")
        print("Phone: \(input.phone.selectedValue?.fullPhoneNumber)")
        print("Date: \(input.birthdate.selectedValue)")
        print("Country: \(input.country.selectedCountry?.countryName)")
    }
    
    func updateInputDefaults() {
        input.dualName.first.selectedValue = "Ahmed"
        input.bio.selectedValue = "dgdfgdgfnhhrgdrf"
        input.privacyAndTerms.selectedValue = true
        input.email.selectedValue = "xxxxxxx@m.c"
        input.phone.selectedValue = PhoneNumber(countryCode: "+20", rawNumber: "1012046739")
        
        form.applyDefaultSelectedValues()
    }
}

public extension ConsentDecorator {
    static let dummy: ConsentDecorator = ConsentDecorator(
        textSlices: [
            NormalTextSlice(text: "I accept"),
            SpaceTextSlice(),
            LinkTextSlice(text: "Terms of use", link: "https://google.com"),
            SpaceTextSlice(),
            NormalTextSlice(text: "and"),
            SpaceTextSlice(),
            LinkTextSlice(text: "Privacy Policy", link: "1"),
            NormalTextSlice(text: ".")
        ],
        
        textColor: .blue,
        checkBoxFillColor: .green,
        checkBoxCheckColor: .red)
}

extension ViewController: PickerFieldDescriptorDelegate {
    
    func pickerFieldDescriptor(_ descriptor: PickerFieldDescriptor, didSelectItemAt selectedIndex: Int?, selectedValue: String?) {
        print("SelectedIndex: \(selectedIndex), SelectedValue: \(selectedValue)")
        input.email.selectedValue = ""
        form.applyDefaultSelectedValues()
        
    }
    
}
