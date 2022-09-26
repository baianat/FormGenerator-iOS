//
//  TextSlice.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 22/03/2021.
//

import Foundation

public protocol TextSlice {
    func appendIn(attributedString: NSMutableAttributedString)
}

public class NormalTextSlice: TextSlice {
    public init(text: String) {
        self.text = text
    }
    
    public let text: String
    
    public func appendIn(attributedString: NSMutableAttributedString) {
        attributedString.appendNormalText(text: text)
    }
}

public class LinkTextSlice: TextSlice {
    public init(text: String, link: String) {
        self.text = text
        self.link = link
    }
    
    public let text: String
    public let link: String
    
    public func appendIn(attributedString: NSMutableAttributedString) {
        attributedString.appendLinkText(text: text, link: link)
    }
}

public class SpaceTextSlice: TextSlice {
    public init() {}
    public func appendIn(attributedString: NSMutableAttributedString) {
        attributedString.appendSpace()
    }
}
