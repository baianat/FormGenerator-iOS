//
//  Extensions.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 10/03/2021.
//

import UIKit
import RxSwift

extension UIView {
    func setStrokeColor(color: CGColor?, width: CGFloat) {
        self.clipsToBounds = true
        self.layer.borderColor = color
        self.layer.borderWidth = width
        self.layer.masksToBounds = true
    }
    
    func setStrokeColor(color: UIColor?, width: CGFloat) {
        self.setStrokeColor(color: color?.cgColor, width: width)
    }
    
    func setCircle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = bounds.height / 2
        self.layer.masksToBounds = true
    }
    
    func setCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    
    func addDashBorder(
        withColor color: UIColor? = nil,
        andWidth width: CGFloat? = nil,
        atRadius cornerRadius: CGFloat = 8,
        withBounds bounds: CGRect? = nil,
        dashSize: NSNumber = 6,
        gapSize: NSNumber = 6
    ) -> CAShapeLayer {
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = color?.cgColor ?? UIColor.white.cgColor
        dashedBorder.lineDashPattern = [dashSize, gapSize]
        dashedBorder.lineJoin = CAShapeLayerLineJoin.round
        dashedBorder.lineWidth = width ?? 1
        dashedBorder.fillColor = nil
        let finalBounds: CGRect //= self.bounds
        if let bounds = bounds {
            finalBounds = bounds
        } else {
            finalBounds = self.bounds
        }
        
        dashedBorder.path = UIBezierPath(roundedRect: finalBounds, cornerRadius: cornerRadius).cgPath
        dashedBorder.frame = finalBounds
    
        return dashedBorder
    }
}

extension UIImageView {
    func tintImage(withColor color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

extension UIView {
    func shake() {
        let midX = center.x
        let midY = center.y
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)
        layer.add(animation, forKey: "position")
    }
}

extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        actions.forEach({addAction($0)})
    }
}

extension Observable {
    func subscribeOnUi(onNext: ((Element) -> Void)?, onError: ((Error) -> Void)?) -> Disposable {
        return observe(on: MainScheduler.instance).subscribe(onNext: onNext, onError: onError, onDisposed: {
            print("-- disposed")
        })
    }
}

extension UICollectionView {
    
    func registerCell(cellType: AnyClass, bundle: Bundle? = nil) {
        let cellId = String.init(describing: cellType)
        register(UINib(nibName: cellId, bundle: Bundle.init(for: cellType)), forCellWithReuseIdentifier: cellId)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ cell: T, forIndex index: IndexPath) -> T {
        let id = String.init(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: id, for: index) as? T ?? cell
    }
}

extension UIViewController {
    private func setupAlertForIPad(_ alert: UIAlertController) {
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: view.bounds.midX,
                                                              y: view.bounds.midY,
                                                              width: 0,
                                                              height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
    
    func presentAlert(_ alert: UIAlertController, completion: (() -> Void)? = nil) {
        setupAlertForIPad(alert)
        present(alert, animated: true, completion: completion)
    }
    
    func showAlert(message: String, dismissHandler: (() -> Void)? = nil) {
        let alert = UIAlertController.init(title: Localize.alert(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: Localize.ok(), style: .default) { _ in
            
        }
        alert.addAction(okAction)
        presentAlert(alert, completion: dismissHandler)
    }
}
