//
//  UIImage.swift
//  BulletTime
//
//  Created by ltebean on 7/29/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    func cropCenterSquare() -> UIImage {
        
        let width  = self.size.width
        let height = self.size.height
        
        let size = width > height ? height : width

        let x = (width  - size) / 2.0
        let y = (height - size) / 2.0
        
        var cropSquare: CGRect
        if imageOrientation == .Left || imageOrientation == .Right {
            cropSquare = CGRectMake(y, x, size, size)
        } else {
            cropSquare = CGRectMake(x, y, size, size)
        }
        
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropSquare)!
        
        return UIImage(CGImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func resize(toSize newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func toBase64String() -> String {
        let data = UIImageJPEGRepresentation(self, 0.8)!
        return data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
    static func imageFromBase64String(base64String: String) -> UIImage {
        let data = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        return UIImage(data: data)!
    }
}
