//
//  MultipleItemPickerComponent.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 29/03/2021.
//

import UIKit
import Vanguard
import RxSwift

typealias SelectedItems = (images: [ImageItem], files: [URL])

public class MultipleItemPickerComponent: FormComponentProtocol {
    let descriptor: MultipleItemPickerDescriptor
    
    let alertPicker = AlertDocumentsPicker()
    let itemsAdapter = VerticalItemsAdapter()
    private lazy var style = FormStyle()
    
    var collectionView: UICollectionView?
    var titleLabel: FormLabel?
    var errorLabel: UILabel?
    let addButton = UIImageView()
    
    let itemsCollectionContainer = BorderStyleContainer()
    let emptyPlaceholder = UIView()
    
    weak var vanguard: Vanguard?
    let key = randomString(length: 4)
    private let disposeBag = DisposeBag()
    
    var validationCase: ValidationCase?
    
    public func isValid() -> Bool {
        return validationCase?.validate() == .valid
    }
    
    public init(descriptor: MultipleItemPickerDescriptor) {
        self.descriptor = descriptor
    }
    
    public func buildComponent(alignments: FormAlignments) -> UIView {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .clear
        itemsAdapter.initialize(collectionView: collectionView!)
        itemsAdapter.delegate = self
        
        let stackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
        
        if let title = getComponentLabel() {
            titleLabel = ViewUtils.createTitleLabel(title: title)
            let titleStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)
            prepareAddButton()
            titleStackView.addArrangedSubview(titleLabel!)
            titleStackView.addArrangedSubview(addButton)
            titleStackView.axis = .horizontal
            
            addButton.setContentHuggingPriority(UILayoutPriority(rawValue: 255), for: .horizontal)
            
            stackView.addArrangedSubview(titleStackView)
        }
        
        let innerStackView = ViewUtils.createStackView(spacing: alignments.componentInnerSpacing)

        itemsCollectionContainer.setHeightEqualToConstant(style.textFieldHeight)
        
        innerStackView.fillIn(container: itemsCollectionContainer)
        innerStackView.addArrangedSubview(collectionView!)
        innerStackView.addArrangedSubview(emptyPlaceholder)
        

        stackView.addArrangedSubview(itemsCollectionContainer)
        
        
        errorLabel = ViewUtils.createErrorLabel()
        stackView.addArrangedSubview(errorLabel!)
        
        prepareEmptyPlaceholder()
        setupActions()
        hideItemsCollection()
        return stackView
    }
    
    private func prepareAddButton() {
        addButton.image = descriptor.decorator.addButtonIcon
        addButton.contentMode = .scaleAspectFit
        addButton.setHeightEqualToConstant(descriptor.decorator.addButtonSize.height)
        addButton.setWidthEqualToConstant(descriptor.decorator.addButtonSize.width)
    }
    
    private func prepareEmptyPlaceholder() {
        let imageView = UIImageView()
        imageView.image = descriptor.decorator.uploadButtonIcon
        
        imageView.setHeightEqualToConstant(
            descriptor.decorator.uploadButtonSize.height)
        imageView.setWidthEqualToConstant(
            descriptor.decorator.uploadButtonSize.width)
        imageView.contentMode = .scaleAspectFit
        imageView.centerIn(container: emptyPlaceholder)
    }
    
    private func setupActions() {
        addButton.isUserInteractionEnabled = true
        emptyPlaceholder.isUserInteractionEnabled = true
        titleLabel?.isUserInteractionEnabled = true
        
        addButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(addAction)
            )
        )
        
        emptyPlaceholder.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(addAction)
            )
        )
        
        titleLabel?.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(addAction)
            )
        )
    }
    
    @objc func addAction() {
        pickFilesAndImagesIfPossible()
        pickFilesOnlyIfPossible()
        pickImagesOnlyIfPossible()
    }
    
    private func pickFilesAndImagesIfPossible() {
        let remainingItemsCount = descriptor.maxNumberOfItems - itemsAdapter.items.count
        if descriptor.canPickFiles && descriptor.canPickImages {
            if remainingItemsCount > 0 {
                subscribeToItemsObservable(
                    observable: alertPicker.show(
                        in: getRootController(),
                        selectionCount: remainingItemsCount
                    )
                )
            } else {
                getRootController()?.showAlert(message: "\(Localize.youCantPickMoreThan()) \(descriptor.maxNumberOfItems) \(Localize.itemsSmall())")
            }
        }
    }
    
    private func pickImagesOnlyIfPossible() {
        let remainingItemsCount = descriptor.maxNumberOfItems - itemsAdapter.items.count
        if !descriptor.canPickFiles && descriptor.canPickImages {
            if remainingItemsCount > 0 {
                subscribeToItemsObservable(
                    observable: alertPicker.showImagesPicker(
                        in: getRootController(),
                        selectionCount: remainingItemsCount
                    )
                )

            } else {
                getRootController()?.showAlert(message: "\(Localize.youCantPickMoreThan()) \(descriptor.maxNumberOfItems) \(Localize.imagesSmall())")
            }
        }
    }
    
    private func pickFilesOnlyIfPossible() {
        let remainingItemsCount = descriptor.maxNumberOfItems - itemsAdapter.items.count
        if descriptor.canPickFiles && !descriptor.canPickImages {
            if remainingItemsCount > 0 {
                subscribeToItemsObservable(
                    observable: alertPicker.showFilesPicker(
                        in: getRootController(),
                        selectionCount: remainingItemsCount
                    )
                )
            } else {
                getRootController()?.showAlert(message: "\(Localize.youCantPickMoreThan()) \(descriptor.maxNumberOfItems) \(Localize.files())")
            }
        }
    }
    
    private func subscribeToItemsObservable(observable: Observable<[ItemDisplayable]>) {
        observable.subscribeOnUi { [weak self] (items) in
            guard let self = self else { return }
            self.appendInItemsAdapter(newItems: items)
            
        } onError: { (error) in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    private func appendInItemsAdapter(newItems: [ItemDisplayable]) {
        showItemsCollection()
        self.itemsAdapter.append(items: newItems)
        vanguard?.validateValue(value: itemsAdapter.items.count, withName: key)
        
        if descriptor.delegate != nil {
            let selectedItems = getSelectedImagesAndFiles()
            descriptor.delegate?.multipleItemPickerDescriptor(
                descriptor,
                didChangeSelectedItems: selectedItems.images,
                selectedItems.files)
        }
    }
    
    public func getComponentLabel() -> String? {
        return descriptor.label
    }
    
    public func applyDefaultValues() {
        var items = [ItemDisplayable]()
        for image in descriptor.selectedImages {
            items.append(ImageDisplayable(image: image.image, url: image.url))
        }
        for file in descriptor.selectedFiles {
            items.append(FileDisplayable(url: file))
        }
        itemsAdapter.update(items: [])
        if items.isEmpty {
            hideItemsCollection()
        } else {
            showItemsCollection()
            itemsAdapter.append(items: items)
        }
        vanguard?.validateValue(value: items.count, withName: key)
    }
    
    public func updateSelectedValue() {
        let selectedItems = getSelectedImagesAndFiles()
        
        descriptor.selectedImages = selectedItems.images
        descriptor.selectedFiles = selectedItems.files
    }
    
    private func getSelectedImagesAndFiles() -> SelectedItems {
        var images = [ImageItem]()
        var files = [URL]()
        
        for item in itemsAdapter.items {
            if let imageDisplayable = item as? ImageDisplayable {
                images.append(ImageItem(image: imageDisplayable.image, url: imageDisplayable.url))
            } else if let file = item as? FileDisplayable,
                      let url = file.url {
                files.append(url)
            }
        }
        
        return SelectedItems(images, files)
    }
    
    public func removeSelectedValue() {
        descriptor.selectedImages = []
        descriptor.selectedFiles = []
    }
    
    public func registerValidation(inVanguard vanguard: Vanguard) {
        self.vanguard = vanguard
        validationCase = vanguard.registerValueComponent(
            withName: key,
            rules: [IntValueRule(predicate: { [weak self] (value) -> Bool in
                guard let self = self else { return false }
                return value >= self.descriptor.minNumberOfItems &&
                    value <= self.descriptor.maxNumberOfItems
            })]
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
        itemsCollectionContainer.updateBorderStyle(
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
        
        if itemsAdapter.items.isEmpty {
            // this function is called to update the height
            hideItemsCollection()
        }
        
        updateContainerStyle()
    }
    
    private func updateContainerStyle() {
        itemsCollectionContainer.updateBorderStyle(
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

extension MultipleItemPickerComponent: VerticalItemsAdapterDelegate {
    func didTapOpenItem(item: ItemDisplayable) {
        if item is ImageDisplayable {
            getRootController()?.displayImage(at: item.url?.absoluteString ?? "", placeHolderImage: nil, delegate: nil)
        } else {
            getRootController()?.displayPdf(at: item.url?.absoluteString ?? "")
        }
    }
    
    func didRemoveAllItems() {
        hideItemsCollection()
    }
    
    func didRemoveItem() {
        vanguard?.validateValue(value: itemsAdapter.items.count, withName: key)
        if descriptor.delegate != nil {
            let selectedItems = getSelectedImagesAndFiles()
            descriptor.delegate?.multipleItemPickerDescriptor(
                descriptor,
                didChangeSelectedItems: selectedItems.images,
                selectedItems.files)
        }
    }
    
    func showItemsCollection() {
        itemsCollectionContainer.heightConstraint?.constant = descriptor.decorator.expandedCollectionHeight
        collectionView?.isHidden = false
        emptyPlaceholder.isHidden = true
    }
    
    func hideItemsCollection() {
        if let height = descriptor.decorator.emptyCollectionHeight {
            itemsCollectionContainer.heightConstraint?.constant = height
        } else {
            itemsCollectionContainer.heightConstraint?.constant = max(style.textFieldHeight, descriptor.decorator.uploadButtonSize.height + 32)
        }
        
        collectionView?.isHidden = true
        emptyPlaceholder.isHidden = false
    }
}
