//
//  CentralViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/30/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import SwiftyJSON
import MultipeerConnectivity
import Async

class CentralViewController: UIViewController {
    
    var cameraController: CameraViewController!
    var recording = false
    
    let host = Host.current
    
    @IBOutlet weak var sharedView: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "camera" {
            cameraController = segue.destinationViewController as! CameraViewController
            cameraController.completion = ({ [weak self] url, error in
                self?.goToEditor(url)
            })
        }
    }
    
    @IBAction func shootButtonPressed(sender: AnyObject) {
        if !recording {
            host.sendStartRecording()
            cameraController.startRecording()
        } else {
            host.sendStopRecording()
            cameraController.stopRecording()
        }
        recording = !recording
        
    }
    
    func goToEditor(url: NSURL) {
        let vc = R.storyboard.shoot.editor()!
        vc.videoURL = url
        vc.videoEndTime = cameraController.endTime
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}


extension CentralViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return sharedView
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return UIColor.blackColor()
    }
}
