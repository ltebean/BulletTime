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
    
    var session : MCSession!
    var centralPeer: MCPeerID!
    let sessionDelegate = SessionDelegate()
    var displayVC: DisplayViewController!
    var videoURL: NSURL!
    var asset: AVAsset!

    @IBOutlet weak var sharedView: UIButton!
    @IBOutlet weak var centralPreviewView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session.delegate = sessionDelegate
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .StartRecording {
                self?.startRecording()
            }
            else if command == .StopRecording {
                self?.stopRecording()
            }
            else if command == .UseFrame {
                let time = data.value!["time"].stringValue
                self?.useFrame(atTime: Float64(time)!)
            }
            else if command == .FinalResult {
                let images = data.value!.arrayValue.map({
                    UIImage.imageFromBase64String($0.stringValue)
                })
                self?.showResult(images)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        centralPreviewView.alpha = 0
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
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(seconds, asset.duration.timescale)
        imageGenerator.generateCGImagesAsynchronouslyForTimes([NSValue(CMTime: time)]) { (requestedTime, image, actualTime, result, error) in
            if let image = image {
                Async.main {
                    self.displayVC = R.storyboard.shoot.display()!
                    self.navigationController?.pushViewController(self.displayVC, animated: true)
                    self.sendImageToCentral(UIImage(CGImage: image).cropCenterSquare())
                }

            }
        }

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

    func sendImageToCentral(image: UIImage) {
        let data = Data(command: .PeerImage, value: JSON(image.toBase64String()))
        session.sendData(data, toPeers: [centralPeer])
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
