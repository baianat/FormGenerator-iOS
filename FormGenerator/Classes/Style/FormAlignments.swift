//
//  FormAlignments.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 24/03/2021.
//

import UIKit

public struct FormAlignments {
    public init(sideMargin: CGFloat = 24, verticalMargin: CGFloat = 8, componentsSpacing: CGFloat = 16, componentInnerSpacing: CGFloat = 8) {
        self.sideMargin = sideMargin
        self.verticalMargin = verticalMargin
        self.componentsSpacing = componentsSpacing
        self.componentInnerSpacing = componentInnerSpacing
    }
    
    public var sideMargin: CGFloat
    public var verticalMargin: CGFloat
    public var componentsSpacing: CGFloat
    public var componentInnerSpacing: CGFloat
}
