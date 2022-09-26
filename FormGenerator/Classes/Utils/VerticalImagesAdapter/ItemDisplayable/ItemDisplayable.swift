//
//  ItemDisplayable.swift
//  AuthenticationModule
//
//  Created by Ahmed Tarek on 12/19/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import Foundation
import UIKit

public protocol ItemDisplayable {
    var url: URL? { get set }
    func display(in imageView: UIImageView)
    func display(in label: UILabel)
}
