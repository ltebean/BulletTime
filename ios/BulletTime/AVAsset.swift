//
//  AVAsset.swift
//  BulletTime
//
//  Created by leo on 16/8/29.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import AVFoundation
import Async

extension AVAsset {
    
    func generateImageAtTime(_ time: CMTime, completion: @escaping (_ image: UIImage?) -> ()) -> AVAssetImageGenerator {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { (requestedTime, image, actualTime, result, error) in
            Async.main {
                if let image = image {
                    completion(UIImage(cgImage: image).cropCenterSquare().resize(toSize: Config.imageSize))
                } else {
                    completion(nil)
                }
            }
        }
        return imageGenerator
    }
    
    func generateImagesAtTimes(_ times: [CMTime], completion: @escaping (_ images: [UIImage]) -> ()) -> AVAssetImageGenerator {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        imageGenerator.appliesPreferredTrackTransform = true
        
        let timesValue = times.map {
            NSValue(time: $0)
        }
        
        var images = [UIImage]()
        imageGenerator.generateCGImagesAsynchronously(forTimes: timesValue) { (requestedTime, image, actualTime, result, error) in
            images.append(UIImage(cgImage: image!).cropCenterSquare().resize(toSize: Config.imageSize))
            if images.count == times.count {
                Async.main {
                    completion(images)
                }
            }
        }
        return imageGenerator
    }
}
