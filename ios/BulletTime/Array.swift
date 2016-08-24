//
//  Array.swift
//  BulletTime
//
//  Created by leo on 16/8/23.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}