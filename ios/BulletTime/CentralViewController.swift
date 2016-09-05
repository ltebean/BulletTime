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
import SVProgressHUD

class CentralViewController: UIViewController {
    
    var cameraController: CameraViewController!
    let host = Host.current
    var shootTime: Float64 = 0
    
    @IBOutlet weak var sharedView: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraController.startRecording()
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
        SVProgressHUD.show()
        shootTime = CFAbsoluteTimeGetCurrent()
        Async.main(after: 0.2, block: {
            self.host.sendStopRecording()
            self.cameraController.stopRecording()
        })
    }
    
    func goToEditor(url: NSURL) {
        let asset = AVAsset(URL: url)
        let startTime = cameraController.startTime
        let seconds = shootTime - startTime
        let times = [seconds - 0.1, seconds, seconds + 0.1]
        let timeValues = times.map {
            CMTimeMakeWithSeconds($0, asset.duration.timescale)
        }
        asset.generateImagesAtTimes(timeValues, completion: { images in
            SVProgressHUD.dismiss()
            let vc = R.storyboard.shoot.picker()!
            vc.times = [self.shootTime - 0.1, self.shootTime, self.shootTime + 0.1]
            vc.images = images
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
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
