//
//  AVCaptureDevice.swift
//  Slowmo
//
//  Created by ltebean on 16/4/16.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import AVFoundation

extension AVCaptureDevice {
    
    static func backCamera() -> AVCaptureDevice {
        return captureDeviceWithPosition(.Back)!
    }
    
    static func frontCamera() -> AVCaptureDevice {
        return captureDeviceWithPosition(.Front)!
    }
    
    private static func captureDeviceWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        return devices.filter({
            $0.position == position
        }).first
    }
    
}
