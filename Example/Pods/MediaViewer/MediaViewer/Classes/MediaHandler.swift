//
//  MediaHandler.swift
//  MediaViewer
//
//  Created by Omar on 2/24/21.
//

import UIKit

public extension UIViewController {
    @discardableResult func displayImage(
        at imageUrl: String,
        placeHolderImage: UIImage? = nil,
        delegate: ImageViewerViewControllerDelegate? = nil
    ) -> UIViewController {
        let vc = ImageViewerViewController.init(withImageUrl: imageUrl, andPlaceHolderImage: placeHolderImage)
        let navigationController = UINavigationController.init(rootViewController: vc)
        vc.delegate = delegate
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
        return navigationController
    }
    
    @discardableResult func displayImage(
        _ image: UIImage,
        delegate: ImageViewerViewControllerDelegate? = nil
    ) -> UIViewController {
        let vc = ImageViewerViewController(withImage: image)
        let navigationController = UINavigationController.init(rootViewController: vc)
        vc.delegate = delegate
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
        return navigationController
    }
}

public extension UIViewController {
    @discardableResult func displayPdf(
        at pdfUrl: String,
        allowDownload: Bool = true,
        delegate: PdfViewerViewControllerDelegate? = nil
    ) -> UIViewController {
        let vc = PdfViewerViewController.init(withUrl: pdfUrl, allowDownload: allowDownload)
        let navigationController = UINavigationController.init(rootViewController: vc)
        vc.delegate = delegate
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
        return navigationController
    }
}
