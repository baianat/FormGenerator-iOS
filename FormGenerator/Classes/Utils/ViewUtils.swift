//
//  ViewUtils.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 11/03/2021.
//

import UIKit

class ViewUtils {
    static func createStackView(spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = spacing
        return stackView
    }
    
    static func createTitleLabel(title: String) -> FormLabel {
        let titleLabel = FormLabel()
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.text = title
        
        return titleLabel
    }
    
    static func createDescriptionLabel(description: String) -> UILabel {
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        return descriptionLabel
    }
    
    static func createSubPickerLabel() -> UILabel {
        let subPickerLabel = UILabel()
        subPickerLabel.numberOfLines = 1
        subPickerLabel.lineBreakMode = .byTruncatingTail
        subPickerLabel.textAlignment = .center
        return subPickerLabel
    }
    
    static func createErrorLabel() -> UILabel {
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.setContentHuggingPriority(.required, for: .vertical)
        
        return errorLabel
    }
    
    static func createZeroHeightFillerView() -> UIView {
        let view = UIView()
        view.setHeightEqualToConstant(0)
        return view
    }
    
    static func createZeroWidthFillerView() -> UIView {
        let view = UIView()
        view.setWidthEqualToConstant(0)
        return view
    }
    
    static func createDividerForHorizontalStack() -> UIView {
        let view = UIView()
        view.setWidthEqualToConstant(1)
        return view
    }
}

extension UIView {
    func fillIn(container: UIView, padding: CGFloat = 0) {
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: padding)
        ])
    }
    
    func setHeightEqualToConstant(_ height: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidthEqualToConstant(_ width: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func centerIn(container: UIView) {
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
    }
    
    func alignLeading(with view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func alignTrailing(with view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func alignBottom(with view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


extension UIView {
    func getOriginRelativeToSupremeView() -> CGPoint {
        return getOriginRelativeToScrollView()
    }
    
    private func getOriginRelativeToScrollView(_ initialPoint: CGPoint = .zero) -> CGPoint {
        if superview == nil || superview is UIScrollView {
            return initialPoint
        } else {
            let newPoint = CGPoint(
                x: initialPoint.x + frame.minX,
                y: initialPoint.y + frame.minY
            )
            return superview?.getOriginRelativeToScrollView(newPoint) ?? initialPoint
        }
    }
}
