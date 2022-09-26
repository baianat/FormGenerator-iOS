//
//  SingleItemPickerDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol SingleItemPickerDescriptorDelegate: class {
    func singleItemPickerDescriptor(
        _ descriptor: SingleItemPickerDescriptor,
        didSelectNewItem newImage: ImageItem?,
        _ newFile: URL?
    )
    
    func singleItemPickerDescriptorDidRemoveSelectedItem(
        _ descriptor: SingleItemPickerDescriptor
    )
}

public class SingleItemPickerDescriptor: Descriptor {
    public init(
        canPickImage: Bool = true,
        canPickFile: Bool = true,
        isRequired: Bool = true,
        decorator: SingleItemPickerDecorator = SingleItemPickerDecorator(),
        label: String? = nil
    ) {
        self.canPickImage = canPickImage
        self.canPickFile = canPickFile
        self.decorator = decorator
        let rules = isRequired ?
            [NotNilRule(errorMessage: ErrorMessages.youMustSelectItem)] : []
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: SingleItemPickerDescriptorDelegate?
    
    var canPickImage: Bool
    var canPickFile: Bool
    
    var decorator: SingleItemPickerDecorator
    
    public var selectedImage: ImageItem?
    public var selectedFile: URL?
    
    public var selectedItem: URL? {
        return selectedImage?.url ?? selectedFile
    }
    
    public override func createComponent() -> FormComponentProtocol {
        return SingleItemPickerComponent(descriptor: self)
    }
}
