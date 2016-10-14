//
//  UIColor.swift
//  Slowmo
//
//  Created by ltebean on 16/4/22.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

public extension UIColor {
    
    public convenience init(hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    public static func colorWithRGB(red: Int, green: Int, blue: Int, alpha: Float = 1) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

public extension UIColor {
    
    static func steppedColor(fromHex: Int, endHex: Int, totalCount: Int, index: Int) -> UIColor {
        if totalCount <= 1 {
            return UIColor(hex: fromHex)
        }
        let fromR = (fromHex & 0xff0000) >> 16
        let fromG = (fromHex & 0x00ff00) >> 8
        let fromB = (fromHex & 0x0000ff)
        
        let endR = (endHex & 0xff0000) >> 16
        let endG = (endHex & 0x00ff00) >> 8
        let endB = (endHex & 0x0000ff)
        
        let r = fromR + (endR - fromR) / (totalCount - 1) * index
        let g = fromG + (endG - fromG) / (totalCount - 1) * index
        let b = fromR + (endB - fromB) / (totalCount - 1) * index

        return UIColor.colorWithRGB(red: r, green: g, blue: b)
    }
}
