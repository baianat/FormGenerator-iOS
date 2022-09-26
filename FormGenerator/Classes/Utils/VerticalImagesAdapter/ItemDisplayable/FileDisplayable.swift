//
//  FileDisplayable.swift
//  AuthenticationModule
//
//  Created by Ahmed Tarek on 12/19/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import Foundation
import UIKit

public class FileDisplayable: ItemDisplayable {
    public var url: URL?
    public var filename: String? {
        return url?.lastPathComponent
    }
    
    public init(url: URL?) {
        self.url = url
    }
    
    public init(urlString: String?) {
        self.url = URL(string: urlString ?? "")
    }
    
    public func display(in imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.iconPdf()
    }
    
    public func display(in label: UILabel) {
        label.text = filename
    }
}
