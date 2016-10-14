//
//  PeripheralViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/30/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import SwiftyJSON
import MultipeerConnectivity
import Async

class PeripheralViewController: UIViewController {

    var cameraController: CameraViewController!
    var displayVC: DisplayViewController!
    var videoURL: URL!
    var asset: AVAsset!
    var imageGenerator: AVAssetImageGenerator!

    var guest = Guest.current()

    @IBOutlet weak var sharedView: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guest.onStopRecording = { [weak self] in
            self?.stopRecording()
        }
        
        guest.onUseFrame = { [weak self] time in
            self?.useFrame(atTime: time)
        }
        
        guest.onReceiveFinalResult = { [weak self] images in
            self?.showResult(images)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRecording()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "camera" {
            cameraController = segue.destination as! CameraViewController
            cameraController.completion = ({ [weak self] url, error in
                self?.videoURL = url as URL!
                self?.asset = AVAsset(url: url as URL)
            })

        }
    }
    
    func useFrame(atTime absoluteTime: Float64) {
        let seconds = absoluteTime - cameraController.startTime
        let time = CMTimeMakeWithSeconds(seconds, asset.duration.timescale)
        imageGenerator = asset.generateImageAtTime(time, completion: { image in
            if let image = image {
                self.guest.sendImage(image)
                self.next()
            } else {
                
            }
        })
    }
    
    
    func showResult(_ images: [UIImage]) {
        displayVC.images = images
    }
    
    func startRecording() {
        print("p start")
        cameraController.startRecording()
    }
    
    func stopRecording() {
        print("p stop")
        cameraController.stopRecording()
    }


    func next() {
        displayVC = R.storyboard.shoot.display()!
        push(displayVC)
    }
    
    
    @IBAction func back(_ sender: AnyObject) {
        pop()
    }
    
}

extension PeripheralViewController: AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return [mainView]
    }
    
    func backgroundColor() -> UIColor {
        return UIColor.black
    }
    
}


