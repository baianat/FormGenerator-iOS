//
//  ImageDisplayable.swift
//  AuthenticationModule
//
//  Created by Ahmed Tarek on 12/17/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import Foundation
import UIKit

public class ImageDisplayable: ItemDisplayable {
    public init(image: UIImage?, url: URL?) {
        self.image = image
        self.url = url
        self.filename = url?.lastPathComponent ?? ImageDisplayable.generateName()
    }
    
    public init(image: UIImage?, filename: String? = nil) {
        self.image = image
        if filename != nil {
            self.filename = filename
        } else {
            self.filename = ImageDisplayable.generateName()
        }
        
        self.url = nil
    }
    
    public init(url: String?) {
        self.url = URL(string: url ?? "")
        self.filename = self.url?.lastPathComponent
        image = nil
    }
    
    public let image: UIImage?
    public var url: URL?
    public let filename: String?
    
    public func display(in imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        if let image = image {
            imageView.image = image
        } else if let url = url {
            imageView.load(fromUrl: url.absoluteString)
        } else {
            imageView.image = UIImage()
        }
    }
    
    public func display(in label: UILabel) {
        label.text = filename
    }
}

extension ImageDisplayable {
    private static func generateName() -> String {
        return Date().timeIntervalSince1970.description + ".JPG"
    }
}
