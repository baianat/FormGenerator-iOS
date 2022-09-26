//
//  ImageUtils.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 29/03/2021.
//

import UIKit
import Nuke
import Photos

extension UIImageView {
    func load(
        fromUrl url: String?,
        placeholder: UIImage? = nil
    ) {
        if let url = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imageUrl = URL(string: url) {
            
            let options = ImageLoadingOptions(
                placeholder: placeholder ?? R.image.image_place_holder(),
                transition: .fadeIn(duration: 0.33), failureImage: placeholder ?? R.image.image_not_found()!,
                contentModes: .init(success: .scaleAspectFill, failure: .scaleAspectFill, placeholder: .scaleAspectFill)
            )
            Nuke.loadImage(with: imageUrl, options: options, into: self, progress: nil) { (_) in
            }
        } else {
            image = placeholder
        }
    }
}

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL: URL?) -> Void)) {
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustment: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, _: [AnyHashable: Any]) -> Void in
                completionHandler(contentEditingInput?.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, _: AVAudioMix?, _: [AnyHashable: Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
