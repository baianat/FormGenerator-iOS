//
//  BorderStyleContainer.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 04/04/2021.
//

import UIKit

struct BorderStyleContainerDecorator {
    var borderStyle: FormBorderStyle = .stroke()
    var borderColor: UIColor = .gray
    var cornerRadius: CGFloat = 8
}

class BorderStyleContainer: UIView {
    
    var decorator = BorderStyleContainerDecorator()
    
    var dashSubLayer: CAShapeLayer?
    
    func updateBorderStyle(decorator: BorderStyleContainerDecorator) {
        self.decorator = decorator
        updateBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateBorder()
    }
    
    private func updateBorder() {
        switch decorator.borderStyle {
        
        case .stroke(let lineWidth):
            setCornerRadius(
                value: decorator.cornerRadius)
            setStrokeColor(
                color: decorator.borderColor,
                width: lineWidth
            )
            
        case .dash(let lineWidth, let dashSize, let gapSize):
            dashSubLayer?.removeFromSuperlayer()
            let width = bounds.width
            let rect = CGRect(
                x: bounds.minX,
                y: bounds.minY,
                width: width,
                height: bounds.height)
            dashSubLayer = addDashBorder(
                withColor: decorator.borderColor,
                andWidth: lineWidth,
                atRadius: decorator.cornerRadius,
                withBounds: rect,
                dashSize: dashSize,
                gapSize: gapSize
            )
            if let sub = dashSubLayer {
                layer.addSublayer(sub)
            }
        }
    }
}
