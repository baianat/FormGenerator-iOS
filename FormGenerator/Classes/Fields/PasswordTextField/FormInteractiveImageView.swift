//
//  InteractiveImageView.swift
//  Rigow
//
//  Created by mac on 4/26/20.
//  Copyright © 2020 Omar. All rights reserved.
//

import Foundation
import UIKit

public class FormInteractiveImageView: UIImageView {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    @IBInspectable var tintingColor: UIColor? {
        didSet {
            if let color = tintingColor {
                self.tintImage(withColor: color)
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.08, delay: 0.0, options: .curveLinear, animations: {
                self.transform = CGAffineTransform.init(scaleX: 0.98, y: 0.95)
            }, completion: nil)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.08, delay: 0.0, options: .curveLinear, animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.08, delay: 0.0, options: .curveLinear, animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }
    
}

public typealias Key = NSAttributedString.Key
