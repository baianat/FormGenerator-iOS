//
//  ParagraphDescriptor.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 18/04/2021.
//

import Foundation
import Vanguard

public protocol ParagraphDescriptorDelegate: class {
    func paragraphDescriptor(
        _ descriptor: ParagraphDescriptor,
        textDidChange newText: String?
    )
}

public enum ParagraphHeight {
    case fixed(height: CGFloat = 80)
    case flexible(minHeight: CGFloat = 80, maxHeight: CGFloat = CGFloat.infinity)
}

public class ParagraphDescriptor: Descriptor {
    public init(label: String? = nil, rules: [Rule] = [], height: ParagraphHeight = .fixed()) {
        self.height = height
        super.init(label: label, rules: rules)
    }
    
    public weak var delegate: ParagraphDescriptorDelegate?
    
    public var height: ParagraphHeight
    public var selectedValue: String?
    
    public override func createComponent() -> FormComponentProtocol {
        let textView = OutlinedTextView()
        return ParagraphComponent(descriptor: self, textView: textView)
    }
}
