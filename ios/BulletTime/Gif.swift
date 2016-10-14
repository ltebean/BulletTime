//
//  Gif.swift
//  BulletTime
//
//  Created by leo on 16/8/3.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class GIF {
    
    static func createGIF(with images: [UIImage], loopCount: Int = 0, frameDelay: Double, toURL url: URL) -> Bool {
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: loopCount]]
        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]]
        
        print(url)
        
        let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeGIF, Int(images.count), nil)!
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary?)
        
        for i in 0..<images.count {
            CGImageDestinationAddImage(destination, images[i].cgImage!, frameProperties as CFDictionary?)
        }
        
        return CGImageDestinationFinalize(destination)
    }
    
}
