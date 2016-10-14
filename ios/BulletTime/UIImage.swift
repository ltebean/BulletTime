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
        if imageOrientation == .left || imageOrientation == .right {
            cropSquare = CGRect(x: y, y: x, width: size, height: size)
        } else {
            cropSquare = CGRect(x: x, y: y, width: size, height: size)
        }
        
        let imageRef = self.cgImage!.cropping(to: cropSquare)!
        
        return UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func resize(toSize newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func toBase64String() -> String {
        let data = UIImageJPEGRepresentation(self, 0.8)!
        return data.base64EncodedString(options: .lineLength64Characters)
    }
    
    static func imageFromBase64String(_ base64String: String) -> UIImage {
        let data = Foundation.Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: data)!
    }
}
