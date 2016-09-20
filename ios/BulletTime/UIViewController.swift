//
//  UIViewController.swift
//  BulletTime
//
//  Created by leo on 16/9/20.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewControllerAnimated(true)
    }
}
