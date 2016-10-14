//
//  PanDirectionGestureRecognizer.swift
//  BulletTime
//
//  Created by leo on 16/8/17.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass



class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    
    enum PanDirection {
        case vertical
        case horizontal
    }
    
    let direction : PanDirection
    
    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if state == .began {
            let velocity = self.velocity(in: self.view!)
            switch direction {
            case .horizontal where fabs(velocity.y) > fabs(velocity.x):
                state = .cancelled
            case .vertical where fabs(velocity.x) > fabs(velocity.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}
