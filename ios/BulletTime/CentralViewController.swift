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
    let host = Host.current()
    var shootTime: Float64 = 0
    var imageGenerator: AVAssetImageGenerator!
    
    @IBOutlet weak var sharedView: UIButton!
    @IBOutlet weak var mainView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraController.startRecording()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "camera" {
            cameraController = segue.destination as! CameraViewController
            cameraController.completion = ({ [weak self] url, error in
                self?.goToEditor(url as URL)
            })
        }
    }
    
    @IBAction func shootButtonPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        shootTime = CFAbsoluteTimeGetCurrent()
        Async.main(after: 0.2, {
            self.host.sendStopRecording()
            self.cameraController.stopRecording()
        })
    }
    
    func goToEditor(_ url: URL) {
        let asset = AVAsset(url: url)
        let startTime = cameraController.startTime
        let seconds = shootTime - startTime
        let times = [seconds - 0.1, seconds, seconds + 0.1]
        let timeValues = times.map {
            CMTimeMakeWithSeconds($0, asset.duration.timescale)
        }
        imageGenerator = asset.generateImagesAtTimes(timeValues, completion: { images in
            SVProgressHUD.dismiss()
            let vc = R.storyboard.shoot.picker()!
            vc.times = [self.shootTime - 0.1, self.shootTime, self.shootTime + 0.1]
            vc.images = images
            self.push(vc)
        })
        
    }
    
    @IBAction func back(_ sender: AnyObject) {
        pop()
    }
    
}


extension CentralViewController: AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return [mainView]
    }
    
    func backgroundColor() -> UIColor {
        return UIColor.black
    }
}
