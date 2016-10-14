//
//  BubbleView.swift
//  BulletTime
//
//  Created by leo on 16/8/15.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class BubbleView: UIView {

    static let startColorHex = 0x77ddac
    static let endColorHex = 0x3ea5ef
    
    var haloView: UIView!
    var label: UILabel!
    
    var color = UIColor.black {
        didSet {
            haloView.backgroundColor = color.withAlphaComponent(0.5)
            label.backgroundColor = color
        }
    }
    
    var text = "" {
        didSet {
            label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func showHalo() {
        haloView.isHidden = false
    }
    
    func hideHalo() {
        haloView.isHidden = true
    }

    
    func setup() {
        backgroundColor = UIColor.clear
        
        haloView = UIView(frame: bounds)
        haloView.layer.masksToBounds = true
        haloView.frame = bounds.insetBy(dx: -10, dy: -10)
        haloView.layer.cornerRadius = haloView.frame.width / 2
        haloView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        addSubview(haloView)
        hideHalo()
        
        label = UILabel(frame: bounds)
        label.layer.cornerRadius = bounds.width / 2
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.textAlignment = .center
        addSubview(label)
    }
    
}
