//
//  SingleItemPickerComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 31/03/2021.
//

import UIKit
import Vanguard
import RxSwift
import MediaViewer

public class SingleItemPickerComponent: FormComponentProtocol {
    private let descriptor: SingleItemPickerDescriptor
    private let alertPicker = AlertDocumentsPicker()
    private lazy var style = FormStyle()
    
    var titleLabel: FormLabel?
    var errorLabel: UILabel?
    
    let emptyPlaceholder = UIView()
    
    private let itemContainer = BorderStyleContainer()
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let selectedFileIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.iconPdf()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let selectedFileLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let selectedFileStackView: UIStackView = {
        let stackView = ViewUtils.createStackView(spacing: 8)
        return stackView
    }()
    
    private weak var vanguard: Vanguard?
    private let key = randomString(length: 4)
    private let disposeBag = DisposeBag()
    private var selectedItem: ItemDisplayable?
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: SingleItemPickerDescriptor) {
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        if let title = getComponentLabel() {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            stackView.addArrangedSubview(titleLabel!)
        }
        
        let innerStackView = ViewUtils.createStackView(spacing: 0)
        innerStackView.alignment = .center
        
        prepareEmptyPlaceholder()
        innerStackView.addArrangedSubview(emptyPlaceholder)
        emptyPlaceholder.alignLeading(with: innerStackView)
        
        prepareSelectedFileStackView()
        innerStackView.addArrangedSubview(selectedFileStackView)
        selectedFileStackView.alignLeading(with: innerStackView)
        
        prepateSelectedImageView()
        innerStackView.addArrangedSubview(selectedImageView)
        
        innerStackView.fillIn(container: itemContainer)
        itemContainer.translatesAutoresizingMaskIntoConstraints = false
        itemContainer.heightAnchor.constraint(equalTo: innerStackView.heightAnchor).isActive = true
        
        stackView.addArrangedSubview(itemContainer)
        
        errorLabel = ViewUtils.createErrorLabel()
        stackView.addArrangedSubview(errorLabel!)
        
        setupActions()
        hideSelectedItem()
        return stackView
    }
    
    private func prepateSelectedImageView() {
        selectedImageView.setCornerRadius(value: descriptor.decorator.cornerRadius)
        NSLayoutConstraint.activate([
            selectedImageView.heightAnchor.constraint(lessThanOrEqualToConstant: descriptor.decorator.maxHeightWhenFilled),
            
            selectedImageView.heightAnchor.constraint(
                equalTo: selectedImageView.widthAnchor,
                multiplier: descriptor.decorator.heightToWidthRatioWhenFilled)
        ])
    }
    
    private func prepareEmptyPlaceholder() {
        let imageView = UIImageView()
        imageView.image = descriptor.decorator.uploadButtonIcon
        imageView.isUserInteractionEnabled = true
        imageView.setHeightEqualToConstant(
            descriptor.decorator.uploadButtonSize.height)
        imageView.setWidthEqualToConstant(
            descriptor.decorator.uploadButtonSize.width)
        imageView.contentMode = .scaleAspectFit
        imageView.centerIn(container: emptyPlaceholder)
        
        updatePlaceholderHeight()
    }
    
    private func updatePlaceholderHeight() {
        emptyPlaceholder.setHeightEqualToConstant(
            max(style.textFieldHeight,
                descriptor.decorator.uploadButtonSize.height + 40))
    }
    
    private func prepareSelectedFileStackView() {
        selectedFileIconImageView.image = descriptor.decorator.docFileIcon
        selectedFileIconImageView.setHeightEqualToConstant(
            descriptor.decorator.docFileIconHeight)
        
        selectedFileStackView.addArrangedSubview(
            ViewUtils.createZeroHeightFillerView())
        selectedFileStackView.addArrangedSubview(selectedFileIconImageView)
        selectedFileStackView.addArrangedSubview(selectedFileLabel)
        selectedFileStackView.addArrangedSubview(
            ViewUtils.createZeroHeightFillerView())
    }
    
    private func setupActions() {
        emptyPlaceholder.isUserInteractionEnabled = true
        selectedImageView.isUserInteractionEnabled = true
        selectedFileIconImageView.isUserInteractionEnabled = true
        selectedFileLabel.isUserInteractionEnabled = true
        
        
        emptyPlaceholder.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(addAction)
            )
        )
        
        selectedImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(optionsAction)
            )
        )
        
        selectedFileLabel.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(optionsAction)
            )
        )
        
        selectedFileIconImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(optionsAction)
            )
        )
    }
    
    @objc func addAction() {
        pickFileOrImageIfPossible()
        pickFileOnlyIfPossible()
        pickImageOnlyIfPossible()
    }
    
    private func pickFileOrImageIfPossible() {
        if descriptor.canPickFile && descriptor.canPickImage {
            subscribleToItemObservable(
                observable: alertPicker.show(in: getRootController(), selectionCount: 1)
            )
        }
    }
    
    private func pickFileOnlyIfPossible() {
        if descriptor.canPickFile && !descriptor.canPickImage {
            subscribleToItemObservable(
                observable: alertPicker.showFilesPicker(in: getRootController(), selectionCount: 1)
            )
        }
    }
    
    private func pickImageOnlyIfPossible() {
        if !descriptor.canPickFile && descriptor.canPickImage {
            subscribleToItemObservable(
                observable: alertPicker.showImagesPicker(in: getRootController(), selectionCount: 1)
            )
        }
    }
    
    private func subscribleToItemObservable(observable: Observable<[ItemDisplayable]>) {
        observable.subscribeOnUi { [weak self] (items) in
            guard let self = self else { return }
            self.setSelectedItem(item: items.first)
        } onError: { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    private func setSelectedItem(item: ItemDisplayable?) {
        selectedItem = item
        showSelectedItem()
        vanguard?.validateValue(value: selectedItem, withName: key)
        
        descriptor.delegate?.singleItemPickerDescriptor(
            descriptor,
            didSelectNewItem: getSelectedImage(),
            getSelectedFile()
        )
    }
    
    private func getSelectedImage() -> ImageItem? {
        if let image = selectedItem as? ImageDisplayable {
            return ImageItem(image: image.image, url: image.url)
        }
        return nil
    }
    
    private func getSelectedFile() -> URL? {
        return selectedItem?.url
    }
    
    @objc func optionsAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openAction = UIAlertAction(title: Localize.open(), style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.openItem()
        }
        
        let removeAction = UIAlertAction(title: Localize.remove(), style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            self.removeItem()
        }
        
        let cancelAction = UIAlertAction(title: Localize.cancel(), style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addActions(openAction, removeAction, cancelAction)
        
        getRootController()?.presentAlert(alert)
    }
    
    private func openItem() {
        if selectedItem is ImageDisplayable {
            getRootController()?.displayImage(at: selectedItem?.url?.absoluteString ?? "", placeHolderImage: nil, delegate: nil)
        } else {
            getRootController()?.displayPdf(at: selectedItem?.url?.absoluteString ?? "")
        }
    }
    
    private func removeItem() {
        selectedItem = nil
        vanguard?.validateValue(value: selectedItem, withName: key)
        hideSelectedItem()
        
        descriptor.delegate?
            .singleItemPickerDescriptorDidRemoveSelectedItem(descriptor)
    }
    
    private func hideSelectedItem() {
        emptyPlaceholder.isHidden = false
        selectedImageView.isHidden = true
        selectedFileStackView.isHidden = true
    }
    
    private func showSelectedItem() {
        emptyPlaceholder.isHidden = true
        if selectedItem is ImageDisplayable {
            selectedImageView.isHidden = false
            selectedFileStackView.isHidden = true
            
            selectedItem?.display(in: selectedImageView)
        }
        
        if selectedItem is FileDisplayable {
            selectedImageView.isHidden = true
            selectedFileStackView.isHidden = false
            
            selectedItem?.display(in: selectedFileIconImageView)
            selectedItem?.display(in: selectedFileLabel)
        }
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        if let imageItem = descriptor.selectedImage {
            selectedItem = ImageDisplayable(image: imageItem.image, url: imageItem.url)
        }
        
        if let file = descriptor.selectedFile {
            selectedItem = FileDisplayable(url: file)
        }
        
        if selectedItem != nil {
            showSelectedItem()
        } else {
            hideSelectedItem()
        }
        
        vanguard?.validateValue(value: selectedItem, withName: key)
    }
    
    public func updateSelectedValue() {
        if let imageDisplayable = selectedItem as? ImageDisplayable {
            descriptor.selectedImage = ImageItem(image: imageDisplayable.image, url: imageDisplayable.url)
            descriptor.selectedFile = nil
        }
        
        if let file = selectedItem as? FileDisplayable {
            descriptor.selectedFile = file.url
            descriptor.selectedImage = nil
        }
    }
    
    public func removeSelectedValue() {
        descriptor.selectedFile = nil
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
        
        updateContainerErrorStyle()
    }
    
    private func updateContainerErrorStyle() {
        itemContainer.updateBorderStyle(
            decorator: BorderStyleContainerDecorator(
                borderStyle: descriptor.decorator.borderStyle,
                borderColor: style.failureColor,
                cornerRadius: descriptor.decorator.cornerRadius
            )
        )
    }
    
    public func removeErrorState() {
        errorLabel?.isHidden = true
        errorLabel?.text = nil
        
        updateContainerStyle()
    }
    
    public func getComponentOrigin() -> CGPoint {
        return titleLabel?.getOriginRelativeToSupremeView() ?? .zero
    }
    
    public func applyStyle(style: FormStyle) {
        self.style = style
        titleLabel?.font = style.titleLabelFont
        titleLabel?.textColor = style.textColor
        titleLabel?.insets = UIEdgeInsets(
            top: 0,
            left: style.titleLabelSidePadding,
            bottom: 0,
            right: style.titleLabelSidePadding
        )
        
        errorLabel?.font = style.errorLabelFont
        errorLabel?.textColor = style.failureColor
        
        selectedFileLabel.font = style.titleLabelFont
        selectedFileLabel.textColor = style.textColor
        
        updatePlaceholderHeight()
        
        updateContainerStyle()
    }
    
    private func updateContainerStyle() {
        itemContainer.updateBorderStyle(
            decorator: BorderStyleContainerDecorator(
                borderStyle: descriptor.decorator.borderStyle,
                borderColor: style.inactiveBorderColor,
                cornerRadius: descriptor.decorator.cornerRadius
            )
        )
    }
    
    public func applyEditingChangeStyle(using editingStylizer: EditingStylizer) {
    }
    
    public func applyConfiguration(configuration: FormConfiguration) {
    }
}
