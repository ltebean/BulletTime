//
//  CameraViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/29/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import CameraEngine
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    
    let cameraEngine = CameraEngine()
    var cameraLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraLayer = cameraEngine.previewLayer
        cameraLayer.frame = previewView.bounds
        let width = UIScreen.mainScreen().bounds.width
        cameraLayer.frame.size = CGSize(width: width, height: width)
        cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.insertSublayer(cameraLayer, atIndex: 0)
        previewView.layer.masksToBounds = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraEngine.sessionPresset = .Photo
        cameraEngine.startSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        cameraEngine.stopSession()
    }
    
    func shoot(completion:(image: UIImage) -> ()) {
        cameraEngine.capturePhoto { image, error in
            let squareImage = image?.cropCenterSquare().resize(toSize: 600)
            completion(image: squareImage!)
        }
    }
    
}
