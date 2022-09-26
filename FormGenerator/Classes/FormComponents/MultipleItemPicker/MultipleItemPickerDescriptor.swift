//
//  MultipleItemPickerDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation

public protocol MultipleItemPickerDescriptorDelegate: class {
    func multipleItemPickerDescriptor(
        _ descriptor: MultipleItemPickerDescriptor,
        didChangeSelectedItems images: [ImageItem],
        _ files: [URL]
    )
}

public class MultipleItemPickerDescriptor: Descriptor {
    public init(
        canPickImages: Bool = true,
        canPickFiles: Bool = true,
        maxNumberOfItems: Int = .max,
        minNumberOfItems: Int = 1,
        decorator: MultipleItemPickerDecorator = MultipleItemPickerDecorator(),
        label: String? = nil
    ) {
        self.maxNumberOfItems = maxNumberOfItems
        self.minNumberOfItems = minNumberOfItems
        self.canPickImages = canPickImages
        self.canPickFiles = canPickFiles
        self.decorator = decorator
        super.init(label: label, rules: [])
    }
    
    public weak var delegate: MultipleItemPickerDescriptorDelegate?
    
    var canPickImages: Bool
    var canPickFiles: Bool
    
    var maxNumberOfItems: Int
    var minNumberOfItems: Int
    
    var decorator: MultipleItemPickerDecorator
    
    public var selectedImages: [ImageItem] = []
    public var selectedFiles: [URL] = []
    
    public var selectedItems: [URL] {
        var items = [URL]()
        items.append(contentsOf: selectedImages.compactMap({$0.url}))
        items.append(contentsOf: selectedFiles)
        return items
    }
    
    public override func createComponent() -> FormComponentProtocol {
        return MultipleItemPickerComponent(descriptor: self)
    }
}
