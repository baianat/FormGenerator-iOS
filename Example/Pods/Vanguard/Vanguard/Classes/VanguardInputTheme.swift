//
//  VanguardInputTheme.swift
//  Vanguard
//
//  Created by Ahmed Tarek on 1/2/21.
//

import UIKit

public protocol VanguardInputTheme {
    func setErrorTheme(_ input: UIView)
    func setNormalTheme(_ input: UIView)
}

public class DefaultTextInputTheme: VanguardInputTheme {
    public func setErrorTheme(_ input: UIView) {
        input.layer.borderColor = UIColor.red.cgColor
        input.layer.borderWidth = 1
        input.layer.cornerRadius = 4
    }
    
    public func setNormalTheme(_ input: UIView) {
        input.layer.borderColor = UIColor.lightGray.cgColor
        input.layer.borderWidth = 1
        input.layer.cornerRadius = 4
    }
    
    public init() {}
    
}

public class NoInputThem: VanguardInputTheme {
    public func setErrorTheme(_ input: UIView) {
        
    }
    
    public func setNormalTheme(_ input: UIView) {
        
    }
    
    public init() {}
}

open class ErrorWithAlertTheme: VanguardInputTheme {
    var errorButton: UIButton!
    open func setErrorTheme(_ input: UIView) {
        input.layer.borderColor = UIColor.red.cgColor
        input.layer.borderWidth = 1
        input.layer.cornerRadius = 4
        
        if let textField = input as? UITextField {
            let height = textField.bounds.height
            let rect = CGRect(x: 0, y: 0, width: height, height: height)
            let rightView = UIView(frame: rect)

            let point = (height/2) - (24/2)
            

            let errorButton = UIImageView(frame: CGRect(x: point, y: point, width: 24, height: 24))
            errorButton.image = UIImage(imageLiteralResourceName: "ExclamationMark")
            errorButton.isUserInteractionEnabled = true

            rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(errorAction)))

            rightView.addSubview(errorButton)

            textField.rightView = rightView
            textField.rightViewMode = .always
        }
        
        
    }
    
    @objc func errorAction() {
        showFormAlert(formStatus: .invalid(resultInfo: .empty()))
    }
    
    open func setNormalTheme(_ input: UIView) {
        input.layer.borderColor = UIColor.lightGray.cgColor
        input.layer.borderWidth = 1
        input.layer.cornerRadius = 4
        
        if let textField = input as? UITextField {
            textField.rightView = nil
        }
    }
    
    public init() {}
}

func showFormAlert(formStatus: ValidationResult) {
    let message: String
    if formStatus == .valid {
        message = "Form is Valid"
    } else {
        message = "Not Valid"
    }
    
    let alert = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(cancelAction)
    UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
}
