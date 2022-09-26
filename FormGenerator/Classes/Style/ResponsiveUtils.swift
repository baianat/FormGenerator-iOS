//
//  ResponsiveUtils.swift
//  Utils
//
//  Created by Omar on 10/19/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit
public func isiPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

public func isLandScape() -> Bool {
    return UIDevice.current.orientation.isLandscape
}

public func isPortrait() -> Bool {
    return UIDevice.current.orientation.isPortrait
}
