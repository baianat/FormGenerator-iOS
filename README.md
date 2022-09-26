# FormGenerator

[![CI Status](https://img.shields.io/travis/Ahmed Tarek/FormGenerator.svg?style=flat)](https://travis-ci.org/Ahmed Tarek/FormGenerator)
[![Version](https://img.shields.io/cocoapods/v/FormGenerator.svg?style=flat)](https://cocoapods.org/pods/FormGenerator)
[![License](https://img.shields.io/cocoapods/l/FormGenerator.svg?style=flat)](https://cocoapods.org/pods/FormGenerator)
[![Platform](https://img.shields.io/cocoapods/p/FormGenerator.svg?style=flat)](https://cocoapods.org/pods/FormGenerator)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FormGenerator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Vanguard', :git => 'https://bitbucket.org/baianat/vanguard-ios.git'
pod 'FormGenerator', :git => 'https://bitbucket.org/baianat/formgenerator-ios.git'
```

## Usage

First things first, you describe your form in a custom class you create using descriptors provided by FormGenerator
```swift
import UIKit
import FormGenerator

class RegisterInput {
    var dualName = HorizontalDualFieldDescriptor(
        first: NameFieldDescriptor(label: "First Name"),
        second: NameFieldDescriptor(label: "Last Name")
    )
    
    var email = EmailFieldDescriptor(label: "Email")
    
    var phone = PhoneFieldDescriptor(label: "Phone")
    
    var city = PickerFieldDescriptor.createWithAlertPicker(alertTitle: "Choose City", label: "City")
    
    var password = PasswordFieldDescriptor(
        shouldUsePasswordMeter: true,
        label: "Password"
    )

    var bio = ParagraphDescriptor(label: "Bio", height: .flexible(minHeight: 54, maxHeight: 120))
    
    var privacyAndTerms = ConsentCheckBoxDescriptor(decorator: .dummy, defaultValue: false)
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
```

Then you instantiate both your class and FormGenerator in your ViewController and just call 
```swift
generate(forInput: input, inContainer: containerView)
```
you can provide UIStackView, UIView or UIScrollView
```swift
import UIKit
import FormGenerator

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var form = FormGenerator()
    var input = RegisterInput()

    override func viewDidLoad() {
        super.viewDidLoad() {
        input.city.values = ["Port Said", "Damietta", "Cairo"]
        
        form.applyStyle(
            style: FormStyle(
                textFieldFont: UIFont.systemFont(ofSize: 16),
                inactiveBorderColor: .gray,
                activeBorderColor: .blue,
                textColor: .black
            )
        )
        
        form.generate(forInput: input, inContainer: containerView)
    }

    @IBAction func buttonAction(_ sender: Any) {
        form.evaluateInput()
    }
}
```

You can validate the form and fill input by calling 
```swift
form.evaluateInput()
```

You can access the entered and selected values from the descriptors in the class you created
```swift
print("First Name: \(input.dualName.first.selectedValue)")
print("Last Name: \(input.dualName.second.selectedValue)")
print("Email: \(input.email.selectedValue)")
print("Phone: \(input.phone.selectedValue?.fullPhoneNumber)")
print("City: \(input.city.selectedValue)")
print("Password: \(input.password.selectedValue)")
print("PrivacyAndTerms: \(input.privacyAndTerms.selectedValue)")
```

## Documentation
##### Descriptors:
###### Name Field Descriptor
Purpose: refers to input field for name
Params: label -> for field title, rules -> for field validation (Rules are provided by Vanguard)
            
###### Email Field Descriptor
Purpose: refers to input field for email
Params: label -> for field title, rules -> for field validation (Rules are provided by Vanguard)

###### Phone Field Descriptor
Purpose: refers to input field for phone numbers

Params: 
defaultCountryCode -> in iso format ex: "eg"
label -> for field title, 
rules -> for field validation (Rules are provided by Vanguard)

###### Picker Field Descriptor
Purpose: refers to input field for picker
Creators: 
Using AlertPicker

```swift
    PickerFieldDescriptor.createWithAlertPicker(
        alertTitle: String? = nil,
        label: String? = nil,
        rules: [Rule] = [NotNilRule(errorMessage: ErrorMessages.youMustSelectValue)]
    )
```
    
or Using UIPickerView
```swift
    public static func createWithPickerView(
        label: String? = nil,
        rules: [Rule] = [NotNilRule(errorMessage: ErrorMessages.youMustSelectValue)]
    )
```
    
you can provide the values to choose, using values property
```swift
    input.city.values = ["Port Said", "Damietta", "Cairo"]
```
and you can access the selected value like this 
```swift
    input.city.selectedIndex
    input.city.selectedValue
```
    
###### Password Field Descriptor
Purpose: refers to input field for password
```swift
    init(
        shouldShowConfirmField: Bool = false,
        shouldUsePasswordMeter: Bool = true,
        label: String? = nil,
        confirmLabel: String? = nil,
        rules: [Rule]
    )
```
    
###### Consent CheckBox Descriptor
Purpose: refers to input field for Agreements and consents like privacy polcicy and terms of use
```swift
    init(decorator: ConsentDecorator, defaultValue: Bool = false)
```
you can set its delegate to control how to open links or use the default behavior

###### Date Picker Field Descriptor
Purpose: refers to input field for Date picker
```swift
    init(
        defaultValue: Date? = nil,
        maxDate: Date? = nil,
        minDate: Date? = nil,
        label: String? = nil,
        rules: [Rule]
    )
```    
    
###### Numbers Field Descriptor
Purpose: refers to input field for Numbers only
```swift
    init(
        label: String? = nil,
        rules: [Rule]
    )
```     
    
###### Paragraph Descriptor
Purpose: refers to input field for TextViews
```swift
    init(
        label: String? = nil, 
        rules: [Rule] = [], 
        height: ParagraphHeight = .fixed()
    )
```    
    
###### Multiple Item Picker Descriptor
Purpose: refers to input field for choosing multiple items files or images
```swift
    init(
        canPickImages: Bool = true,
        canPickFiles: Bool = true,
        maxNumberOfItems: Int = .max,
        minNumberOfItems: Int = 1,
        decorator: MultipleItemPickerDecorator = MultipleItemPickerDecorator(),
        label: String? = nil
    )
```     
    
###### Single Item Picker Descriptor
Purpose: refers to input field for choosing single item file or image
```swift
    init(
        canPickImage: Bool = true,
        canPickFile: Bool = true,
        isRequired: Bool = true,
        decorator: SingleItemPickerDecorator = SingleItemPickerDecorator(),
        label: String? = nil
    )
```       
    
###### Horizontal Dual Field Descriptor
Purpose: puts two field beside each other horizontally
```swift
    init(first: FirstDescriptor, second: SecondDescriptor)
```     
    
###### Multiple Fields Descriptor
Purpose: refers to input field for adding multiple values in multiple fields
```swift
    init(
        minNumberOfItems: Int = 1,
        maxNumberOfItems: Int = .max,
        label: String? = nil,
        fieldPlaceholder: String? = nil,
        rules: [Rule] = []
    )
```     
    
###### Custom Descriptor
Purpose: puts a custom view in the form, it requires custom handling by the developer
```swift
    init(customComponent: Custom)
```     
    
you can subclass CustomFormComponent and override buildComponent function like this
```swift
    class CustomFieldViewComponent: CustomFormComponent {
        override func buildComponent(alignments: FormAlignments) -> UIView {
            let view = UIView()
            view.height(100)
            view.backgroundColor = .magenta
            return view
        }
    }
```
    
    
##### Options:
You can use different options provided in FormGenerator class

```swift
    var enableRealTimeValidation: Bool
    var showErrorLabels: Bool 
    var showPlaceholders: Bool
    
    func applyStyle(style: FormStyle)
    func setAlignments(alignments: FormAlignments)
    func applyDefaultSelectedValues()
```

you can also set the default values in the input's descriptors and make the form append thos values to the corresponding fields

## Author

Baianat, development@baianat.com

## License

FormGenerator is available under the MIT license. See the LICENSE file for more info.
