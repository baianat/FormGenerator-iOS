//
//  ProfilePictureComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 11/04/2021.
//

import UIKit
import RxSwift
import MediaViewer
import Vanguard

public class ProfilePicturePickerComponent: FormComponentProtocol {
    private let descriptor: ProfilePicturePickerDescriptor
    private let alertPicker = AlertDocumentsPicker()
    private lazy var style = FormStyle()
    
    var titleLabel: FormLabel?
    var errorLabel: UILabel?
    
    private let selectedImageContainer = UIView()
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let pickImageButton = UIView()
     
    private weak var vanguard: Vanguard?
    private let key = randomString(length: 4)
    private let disposeBag = DisposeBag()
    private var selectedItem: ImageDisplayable? {
        didSet {
            if let displayable = selectedItem {
                displayable.display(in: selectedImageView)
            } else {
                setPlaceholderImage()
            }
        }
    }
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: ProfilePicturePickerDescriptor) {
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        stackView.alignment = .center
        
        stackView.addArrangedSubview(selectedImageContainer)
        selectedImageView.fillIn(container: selectedImageContainer)
        prepareSelectedImageView()
        setupActions()
        
        if let title = getComponentLabel() {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            stackView.addArrangedSubview(titleLabel!)
            titleLabel?.alignLeading(with: stackView)
            titleLabel?.textAlignment = .center
        }
        
        errorLabel = ViewUtils.createErrorLabel()
        stackView.addArrangedSubview(errorLabel!)
        errorLabel?.alignLeading(with: stackView)
        errorLabel?.textAlignment = .center
        
        return stackView
    }
    
    public func getComponentOrigin() -> CGRect {
        return selectedImageContainer.superview?.frame ?? .zero
    }
    
    private func prepareSelectedImageView() {
        updateSelectedImageSize()
        updateFrameStyle()
        setPlaceholderImage()
        
        if descriptor.decorator.showPickButton {
            pickImageButton.isHidden = false
            updatePickerImageButtonSize()
            pickImageButton.backgroundColor = descriptor.decorator.pickButtonColor
            setupIconInPickerButton()
        } else {
            pickImageButton.isHidden = true
        }
    }
    
    private func updateFrameStyle() {
        switch descriptor.decorator.frameStyle {
        case .circle:
            selectedImageView.setCornerRadius(value: descriptor.decorator.imageViewSize/2)
            
        case .square(let cornerRadius):
            selectedImageView.setCornerRadius(value: cornerRadius)
        }
    }
    
    private func setPlaceholderImage() {
        selectedImageView.image = descriptor.decorator.placeholderImage
    }
    
    private func updatePickerImageButtonSize() {
        pickImageButton.setHeightEqualToConstant(descriptor.decorator.pickButtonSize)
        pickImageButton.setWidthEqualToConstant(descriptor.decorator.pickButtonSize)
        
        selectedImageContainer.addSubview(pickImageButton)
        pickImageButton.alignTrailing(with: selectedImageContainer)
        pickImageButton.alignBottom(with: selectedImageContainer)
        
        pickImageButton.setCornerRadius(value: descriptor.decorator.pickButtonSize/2)
    }
    
    private func updateSelectedImageSize() {
        selectedImageContainer.setHeightEqualToConstant(descriptor.decorator.imageViewSize)
        selectedImageContainer.setWidthEqualToConstant(descriptor.decorator.imageViewSize)
    }
    
    private func setupIconInPickerButton() {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = descriptor.decorator.pickButtonIcon
        let iconHeight = descriptor.decorator.pickButtonSize*1/2
        iconImageView.setHeightEqualToConstant(iconHeight)
        iconImageView.setWidthEqualToConstant(iconHeight)
        
        iconImageView.centerIn(container: pickImageButton)
    }
    
    private func setupActions() {
        pickImageButton.isUserInteractionEnabled = true
        selectedImageView.isUserInteractionEnabled = true
        
        pickImageButton.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(pickImageButtonGestureHandler))
        )
        
        selectedImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectedImageViewGestureHandler))
        )
    }
    
    @objc func pickImageButtonGestureHandler() {
        pickImageAction()
    }
    
    @objc func selectedImageViewGestureHandler() {
        if selectedItem != nil {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let previewAction = UIAlertAction(title: Localize.preview(), style: .default) { [weak self] (_) in
                guard let self = self else { return }
                self.previewImageAction()
            }
            
            let changeAction = UIAlertAction(title: Localize.change(), style: .default) { [weak self] (_) in
                guard let self = self else { return }
                self.pickImageAction()
            }
            
            let cancelAction = UIAlertAction(title: Localize.cancel(), style: .cancel)
            
            alert.addActions(previewAction, changeAction, cancelAction)
            alert.show()
        } else {
            pickImageAction()
        }
    }
    
    private func previewImageAction() {
        
        getRootController()?.displayImage(at: selectedItem?.url?.absoluteString ?? "", placeHolderImage: descriptor.decorator.placeholderImage, delegate: nil)
    }
    
    private func pickImageAction() {
        alertPicker.showImagesPicker(in: getRootController(), selectionCount: 1).subscribeOnUi { [weak self] (items) in
            guard let self = self else { return }
            self.setSelectedItem(item: items.first)
        } onError: { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    private func setSelectedItem(item: ItemDisplayable?) {
        selectedItem = item as? ImageDisplayable
        vanguard?.validateValue(value: selectedItem, withName: key)
        
        descriptor.delegate?.profilePicturePickerDescriptor(descriptor, didSelectNewImage: ImageItem(image: selectedItem?.image, url: selectedItem?.url))
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        if let imageItem = descriptor.selectedImage {
            selectedItem = ImageDisplayable(image: imageItem.image, url: imageItem.url)
        }
        
        vanguard?.validateValue(value: selectedItem, withName: key)
    }
    
    public func updateSelectedValue() {
        if let item = selectedItem {
            descriptor.selectedImage = ImageItem(image: item.image, url: item.url)
        }
    }
    
    public func removeSelectedValue() {
        descriptor.selectedImage = nil
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        self.vanguard = vanguard
        validationCase = vanguard.registerValueComponent(
            withName: key,
            rules: descriptor.rules
        )
    }
    
    public func hasComponent(vanguardComponent: VanguardComponent) -> Bool {
        guard let component = vanguardComponent.component as? String else {
            return false
        }
        return component == key
    }
    
    public func setErrorState(errorMessage: String?, shouldHideErrorLabel: Bool) {
        let error: String?
        if descriptor.simplifiedErrorMessage != nil {
            error = descriptor.simplifiedErrorMessage
        } else {
            error = errorMessage
        }
        
        errorLabel?.isHidden = shouldHideErrorLabel || (error == nil)
        errorLabel?.text = error
        
        updateSelectedImageErrorStyle()
    }
    
    private func updateSelectedImageErrorStyle() {
        selectedImageView.setStrokeColor(color: style.failureColor, width: style.textFieldBorderWidth)
    }
    
    public func removeErrorState() {
        errorLabel?.isHidden = true
        errorLabel?.text = nil
        
        selectedImageView.setStrokeColor(color: .clear, width: 0)
    }
    
    public func getComponentOrigin() -> CGPoint {
        return selectedImageContainer.getOriginRelativeToSupremeView()
    }
    
    public func applyStyle(style: FormStyle) {
        self.style = style
        titleLabel?.font = style.titleLabelFont
        titleLabel?.insets = UIEdgeInsets(
            top: 0,
            left: style.titleLabelSidePadding,
            bottom: 0,
            right: style.titleLabelSidePadding
        )
        
        if let titleColor = descriptor.decorator.titleColor {
            titleLabel?.textColor = titleColor
        } else {
            titleLabel?.textColor = style.textColor
        }
        
        errorLabel?.font = style.errorLabelFont
        errorLabel?.textColor = style.failureColor
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
    }
}
