//
//  AlertPicker.swift
//  AbjadUtils
//
//  Created by Ahmed Tarek on 12/26/20.
//  Copyright © 2020 Baianat. All rights reserved.
//

import UIKit
import RxSwift
import YPImagePicker
import MobileCoreServices

public class AlertDocumentsPicker: NSObject {
    let disposeBag = DisposeBag()
    var subject: PublishSubject<[ItemDisplayable]>!
    var selectionCount = 1
    let maximumSizeInMB: Double = 10
    
    public func show(
        in viewController: UIViewController?,
        selectionCount: Int
    ) -> Observable<[ItemDisplayable]> {
        subject = PublishSubject()
        self.selectionCount = selectionCount
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let imagesAction = UIAlertAction(title: Localize.images(), style: .default) { [weak self, viewController] (_) in
            guard let self = self else { return }
            self.launchImagesPicker(viewController: viewController)
        }
        
        let filesAction = UIAlertAction(title: Localize.files(), style: .default) { [weak self, viewController] (_) in
            self?.openFilesPicker(viewController: viewController)
        }
        
        let cancelAction = UIAlertAction(title: Localize.cancel(), style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
         
        alert.addActions(imagesAction, filesAction, cancelAction)
        viewController?.presentAlert(alert)
        
        return subject.asObservable()
    }
    
    public func showImagesPicker(
        in viewController: UIViewController?,
        selectionCount: Int
    ) -> Observable<[ItemDisplayable]> {
        subject = PublishSubject()
        self.selectionCount = selectionCount
        
        launchImagesPicker(viewController: viewController)
        
        return subject.asObservable()
    }
    
    public func showFilesPicker(
        in viewController: UIViewController?,
        selectionCount: Int
    ) -> Observable<[ItemDisplayable]> {
        subject = PublishSubject()
        self.selectionCount = selectionCount
        
        openFilesPicker(viewController: viewController)
        
        return subject.asObservable()
    }
    
    private func launchImagesPicker(viewController: UIViewController?) {
        viewController?.launchImagePickerDefault(
            selectionCount: selectionCount,
            dismissCompletion: { [weak self] (items) in
                guard let self = self else { return }
                
                self.prepareSelectedImages(items: items).subscribeOnUi { [weak self] (images) in
                    self?.subject.onNext(images)
                } onError: { [weak self] (error) in
                    print(error)
                    self?.subject.onError(error)
                }.disposed(by: self.disposeBag)
            },
            selectCompletion: {_ in}
        )
    }
    
    private func prepareSelectedImages(items: [YPMediaItem]) -> Observable<[ImageDisplayable]> {
        return Observable.combineLatest(
            items.map({ (item) in
                convertYPMediaItemToImageDisplayable(media: item)
            })
        )
    }
    
    private func convertYPMediaItemToImageDisplayable(
        media: YPMediaItem
    ) -> Observable<ImageDisplayable> {
        let subject = ReplaySubject<ImageDisplayable>.create(bufferSize: 1)
        
        switch media {
        case .photo(let photo):
        
            photo.asset?.getURL(completionHandler: { [weak self] (url) in
                guard let self = self else { return }
                if let url = url {
                    let size = FileUtils.getFileSizeFromDataInMB(data: try? Data(contentsOf: url))
                    guard size <= self.maximumSizeInMB else {
                        subject.onError(FormCustomError(errorDescription: "\(Localize.fileSizeCantExceed()) \(self.maximumSizeInMB) \(Localize.megaByte())"))
                        return
                    }
                    let imageDisplayable = ImageDisplayable(image: photo.image, url: url)
                    subject.onNext(imageDisplayable)
                    subject.onCompleted()
                } else {
//                    subject.onError(FormCustomError(errorDescription: Localize.invalidMedia()))
                    let imageDisplayable = ImageDisplayable(image: photo.image, url: nil)
                    subject.onNext(imageDisplayable)
                    subject.onCompleted()
                }
            })
            
        default:
            break
        }
        return subject.asObservable()
    }
    
    private func openFilesPicker(viewController: UIViewController?) {
        let documentPicker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            documentPicker = UIDocumentPickerViewController(
                forOpeningContentTypes: [.pdf],
                asCopy: true
            )
        } else {
            documentPicker = UIDocumentPickerViewController(
                documentTypes: [String(kUTTypePDF)],
                in: .import
            )
        }
        
        documentPicker.allowsMultipleSelection = selectionCount > 1
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        viewController?.present(documentPicker, animated: true, completion: nil)
    }
     
}

extension AlertDocumentsPicker: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard urls.count <= selectionCount else {
            subject.onError(FormCustomError(errorDescription: "\(Localize.selectedFilesCantBeMoreThan()) \(selectionCount)"))
            return
        }
        
        for item in urls {
            let size = FileUtils.getFileSizeFromDataInMB(data: try? Data(contentsOf: item))
            guard size <= maximumSizeInMB else {
                subject.onError(FormCustomError(errorDescription: "\(Localize.fileSizeCantExceed()) \(self.maximumSizeInMB) \(Localize.megaByte())"))
                return
            }
        }
        
        subject.onNext(
            urls.map({ (url) in
                FileDisplayable(url: url)
            })
        )
        subject.onCompleted()
    }
}

extension UIViewController {
    func launchImagePickerDefault(
        selectionCount: Int,
        dismissCompletion: (([YPMediaItem]) -> Void)? = nil,
        selectCompletion: @escaping ([YPMediaItem]) -> Void,
        preselectedItems: [YPMediaItem]? = nil
    ) {
        var config = YPImagePickerConfiguration()
        
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = true
        
        if let preselected = preselectedItems {
            config.library.preSelectItemOnMultipleSelection = true
            config.library.preselectedItems = preselected
        }
        
        config.library.maxNumberOfItems = selectionCount
        config.screens = [.library]
        config.library.mediaType = .photo
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            selectCompletion(items)
            picker.dismiss(animated: true) {
                dismissCompletion?(items)
            }
        }
        
        present(picker, animated: true, completion: nil)
        
    }
}
