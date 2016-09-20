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
    
    func generateImageAtTime(time: CMTime, completion: (image: UIImage?) -> ()) {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.generateCGImagesAsynchronouslyForTimes([NSValue(CMTime: time)]) { (requestedTime, image, actualTime, result, error) in
            Async.main {
                if let image = image {
                    completion(image: UIImage(CGImage: image).cropCenterSquare().resize(toSize: Config.imageSize))
                } else {
                    completion(image: nil)
                }
            }
        }
    }
    
    func generateImagesAtTimes(times: [CMTime], completion: (images: [UIImage]) -> ()) -> AVAssetImageGenerator {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        imageGenerator.appliesPreferredTrackTransform = true
        
        let timesValue = times.map {
            NSValue(CMTime: $0)
        }
        
        var images = [UIImage]()
        imageGenerator.generateCGImagesAsynchronouslyForTimes(timesValue) { (requestedTime, image, actualTime, result, error) in
            images.append(UIImage(CGImage: image!).cropCenterSquare().resize(toSize: Config.imageSize))
            if images.count == times.count {
                Async.main {
                    completion(images: images)
                }
            }
        }
        return imageGenerator
    }
}
