//
//  UIViewController.swift
//  BulletTime
//
//  Created by leo on 16/9/20.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func pop() {
        let _ = navigationController?.popViewController(animated: true)
    }

}
