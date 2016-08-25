//
//  UIView.swift
//  BulletTime
//
//  Created by leo on 16/8/25.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
//        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

