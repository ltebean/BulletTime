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
    var videoURL: NSURL!
    var asset: AVAsset!
    
    var guest = Guest.current

    @IBOutlet weak var sharedView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guest.onStartRecording = { [weak self] in
            self?.startRecording()
        }
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "camera" {
            cameraController = segue.destinationViewController as! CameraViewController
            cameraController.completion = ({ [weak self] url, error in
                self?.videoURL = url
                self?.asset = AVAsset(URL: url)
            })

        }
    }
    
    func useFrame(atTime absoluteTime: Float64) {
        let seconds = absoluteTime - (cameraController.endTime - CMTimeGetSeconds(asset.duration))
        let time = CMTimeMakeWithSeconds(seconds, asset.duration.timescale)
        asset.generateImageAtTime(time, completion: { image in
            if let image = image {
                self.guest.sendImage(image)
                self.next()
            } else {
                
            }
        })
    }
    
    
    func showResult(images: [UIImage]) {
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
        navigationController?.pushViewController(self.displayVC, animated: true)
    }
    
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}


extension PeripheralViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return sharedView
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return UIColor.blackColor()
    }
}
