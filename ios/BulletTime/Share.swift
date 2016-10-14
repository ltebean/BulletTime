//
//  Share.swift
//  BulletTime
//
//  Created by leo on 16/8/16.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit
import MobileCoreServices
//import Alamofire
import SVProgressHUD
import Photos

class ShareItem: NSObject, UIActivityItemSource {
    
    let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        return data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivityType?) -> String {
        return CFBridgingRetain(kUTTypeMPEG4) as! String
    }
}

class Share: NSObject {
    
//    static func shareProduct(product: Product, inViewController vc: UIViewController) {
//        SVProgressHUD.show()
//        vc.view.userInteractionEnabled = false
//        
//        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("animated.gif")
//        do {
//            try NSFileManager.defaultManager().removeItemAtURL(url)
//        } catch {
//            
//        }
//        GIF.createGIF(with: product.images, frameDelay: Config.frameInterval, toURL: url)
//        let uuid = product.uuid.dataUsingEncoding(NSUTF8StringEncoding)!
//        let shareURL = NSURL(string: "\(Config.serverURL)/p/\(product.uuid)")!
//        Alamofire.upload(
//            .POST,
//            "\(Config.serverURL)/api/v1/upload",
//            multipartFormData: { multipartFormData in
//                multipartFormData.appendBodyPart(fileURL: url, name: "gif")
//                multipartFormData.appendBodyPart(data: uuid, name: "uuid")
//            },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { response in
//                        vc.view.userInteractionEnabled = true
//                        if response.result.isSuccess {
//                            SVProgressHUD.dismiss()
//                            Share.shareURL(shareURL, inViewController: vc)
//                        } else {
//                            SVProgressHUD.showErrorWithStatus("Network Error")
//                        }
//                    }
//                case .Failure(let encodingError):
//                    vc.view.userInteractionEnabled = true
//                    SVProgressHUD.showErrorWithStatus("Error")
//                    print(encodingError)
//                }
//            }
//        )
//        
//    }

    fileprivate static func shareURL(_ url: URL, inViewController vc: UIViewController) {
        let activityVC = UIActivityViewController(activityItems:[url], applicationActivities: nil)
        vc.present(activityVC, animated: true, completion: nil)
    }
    
    static func shareAsVideo(_ product: Product, inViewController vc: UIViewController) {
        let images = product.images
        SVProgressHUD.show()
        vc.view.isUserInteractionEnabled = false

        let settings = CEMovieMaker.videoSettings(withCodec: AVVideoCodecH264, withWidth: 600, andHeight: 600)
        let maker = CEMovieMaker(settings: settings)!
        var finalImages = [UIImage]()
        for _ in 1...5 {
            finalImages.append(contentsOf: images)
            finalImages.append(contentsOf: images.reversed())

        }
        maker.createMovie(from: finalImages, withCompletion: { url in
            SVProgressHUD.dismiss()
            vc.view.isUserInteractionEnabled = true
            let data = try! Data(contentsOf: url!)
            print(url, data)
            let activityVC = UIActivityViewController(activityItems:[url!], applicationActivities: nil)
            vc.present(activityVC, animated: true, completion: nil)
        })

    }
}
