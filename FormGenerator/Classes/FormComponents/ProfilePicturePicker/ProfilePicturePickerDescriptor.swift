//
//  ProfilePicturePickerDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol ProfilePicturePickerDescriptorDelegate: class {
    func profilePicturePickerDescriptor(
        _ descriptor: ProfilePicturePickerDescriptor,
        didSelectNewImage image: ImageItem?
    )
}

public class ProfilePicturePickerDescriptor: Descriptor {
    public init(
        isRequired: Bool = true,
        decorator: ProfilePicturePickerDecorator = ProfilePicturePickerDecorator(),
        label: String? = nil
    ) {
        self.decorator = decorator
        let rules = isRequired ?
            [NotNilRule(errorMessage: ErrorMessages.youMustSelectItem)] : []
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: ProfilePicturePickerDescriptorDelegate?
    
    var decorator: ProfilePicturePickerDecorator
    
    public var selectedImage: ImageItem?

    public override func createComponent() -> FormComponentProtocol {
        return ProfilePicturePickerComponent(descriptor: self)
    }
}
