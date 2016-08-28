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
    var displayVC: DisplayViewController!
    
    var peer: MCPeerID!
    var session : MCSession! {
        didSet {
            session.delegate = sessionDelegate
        }
    }
    var peers: [MCPeerID] = []
    var imageReceived: [MCPeerID: UIImage] = [:]
    var imageTaken: UIImage?
    let sessionDelegate = SessionDelegate()
    var lastSyncTime = NSDate().timeIntervalSince1970
    var recording = false
    let ciContext = CIContext()
    
    
    @IBOutlet weak var sharedView: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageTaken = nil
        imageReceived = [:]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
            let data = Data(command: .StartRecording)
            session.sendData(data, toPeers: peers)
            cameraController.startRecording()
            recording = true
        } else {
            let data = Data(command: .StopRecording)
            session.sendData(data, toPeers: peers)
            cameraController.stopRecording()
        }
        
//        let data = Data(command: .Shoot)
//        session.sendData(data, toPeers: peers)
//        cameraController.shoot { [weak self] image in
//            guard let this = self else {
//                return
//            }
//            this.imageTaken = image
//            this.displayVC = R.storyboard.shoot.display()!
//            this.navigationController?.pushViewController(this.displayVC, animated: true)
//            this.mergeImagesIfFinshed()
//        }
    }
    
    func goToEditor(url: NSURL) {
        let vc = R.storyboard.shoot.editor()!
        vc.peer = peer
        vc.peers = peers
        vc.session = session
        vc.videoURL = url
        vc.videoEndTime = cameraController.endTime
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func next() {
        displayVC = R.storyboard.shoot.display()!
        navigationController?.pushViewController(displayVC, animated: true)
    }
    
    private func sampleBufferToImage(sampleBuffer: CMSampleBuffer!) -> UIImage {
        let pixelBuffer:CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let ciImage = CIImage(CVPixelBuffer: pixelBuffer)
        
        let pixelBufferWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let pixelBufferHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let imageRect:CGRect = CGRectMake(0,0,pixelBufferWidth, pixelBufferHeight)
        let cgimage = ciContext.createCGImage(ciImage, fromRect: imageRect)

        let image = UIImage(CGImage: cgimage)
        return image
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
