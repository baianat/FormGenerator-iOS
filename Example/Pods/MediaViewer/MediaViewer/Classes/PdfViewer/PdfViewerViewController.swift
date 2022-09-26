//
//  PdfViewerViewController.swift
//  Utils
//
//  Created by Omar on 2/22/21.
//  Copyright © 2021 Baianat. All rights reserved.
//

import UIKit
import WebKit

public protocol PdfViewerViewControllerDelegate: class {
    func pdfViewerViewController(_ pdfViewerViewController: PdfViewerViewController, didDownloadPdfInto downloadedFileURL: URL)
    func pdfViewerViewController(_ pdfViewerViewController: PdfViewerViewController, didFailDownloadingWithError error: Error)
    func pdfViewerViewControllerWasDismissed(_ pdfViewerViewController: PdfViewerViewController)
}
public extension PdfViewerViewControllerDelegate {
    func pdfViewerViewController(_ pdfViewerViewController: PdfViewerViewController, didDownloadPdfInto downloadedFileURL: URL) {}
    func pdfViewerViewController(_ pdfViewerViewController: PdfViewerViewController, didFailDownloadingWithError error: Error) {}
    func pdfViewerViewControllerWasDismissed(_ pdfViewerViewController: PdfViewerViewController) {}
}
public class PdfViewerViewController: UIViewController {
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(withUrl url: String, allowDownload: Bool) {
        self.url = url
        self.allowDownload = allowDownload
        super.init(
            nibName: String(describing: PdfViewerViewController.self),
            bundle: Bundle.init(for: PdfViewerViewController.self)
        )
    }

    // MARK:- Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK:- BarButtons
    private lazy var spinnerBarButton: UIBarButtonItem = {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        spinner.startAnimating()
        return UIBarButtonItem(customView: spinner)
    }()
    
    private lazy var saveBarButton = UIBarButtonItem.init(
        title: "save".localized,
        style: .plain,
        target: self,
        action: #selector(moreAction)
    )
    private lazy var doneBarButton = UIBarButtonItem.init(
        title: "done".localized,
        style: .done,
        target: self,
        action: #selector(doneAction)
    )
    
    public weak var delegate: PdfViewerViewControllerDelegate?
    private let url: String
    private let allowDownload: Bool
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        displayPdf()
        setupNavigationBar()
    }
    
    private func displayPdf() {
        if let fileUrl = URL(string: url) {
            let myDocument = URLRequest(url: fileUrl)
            activityIndicator.startAnimating()
            navigationItem.title = fileUrl.lastPathComponent
            webView.load(myDocument)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            webView.navigationDelegate = self
        }
    }
    private func setupNavigationBar() {
        if allowDownload {
            self.navigationItem.rightBarButtonItems = [saveBarButton]
        }
        self.navigationItem.leftBarButtonItems = [doneBarButton]
    }
    @objc func moreAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let downloadAction = UIAlertAction(title: "save".localized,
                                           style: .default) { (_) in
            self.downloadFile()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        alert.addAction(downloadAction)
        alert.addAction(cancelAction)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: view.bounds.midX,
                                                              y: view.bounds.midY,
                                                              width: 0,
                                                              height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
        present(alert, animated: true, completion: nil)
    }
    @objc func doneAction() {
        dismiss(animated: true) {
            self.delegate?.pdfViewerViewControllerWasDismissed(self)
        }
    }
    private func downloadFile() {
        let fileURL = URL(string: url)
        self.navigationItem.rightBarButtonItems = [spinnerBarButton]
        DispatchQueue.global().async {
            let pdfData = try? Data.init(contentsOf: fileURL!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrlArr = self.url.components(separatedBy: "/")
            
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrlArr.last ?? self.appSignature())
            
            do {
                _ = try pdfData?.write(to: actualPath, options: .atomic)
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItems = [self.saveBarButton]
                    self.delegate?.pdfViewerViewController(self, didDownloadPdfInto: actualPath)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.delegate?.pdfViewerViewController(self, didFailDownloadingWithError: error)
                    self.navigationItem.rightBarButtonItems = [self.saveBarButton]
                }
            }
        }
    }
    
    private func appSignature() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MMM.yyyy.HH:mm:ss"
        let date = formatter.string(from: Date())
        return "\(appName()) \(date).pdf"
    }
    private func appName() -> String {
        (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
    }
}

extension PdfViewerViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        webView.isHidden = false
    }
}
