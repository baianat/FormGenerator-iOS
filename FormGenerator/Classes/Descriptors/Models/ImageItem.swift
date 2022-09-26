//
//  Item.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 29/03/2021.
//

import UIKit

public struct ImageItem {
    public init(image: UIImage? = nil, url: URL?) {
        self.image = image
        self.url = url
    }
    
    public let image: UIImage?
    public let url: URL?
}
