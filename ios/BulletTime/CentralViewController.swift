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
    
    let ciContext = CIContext()
    
    
    @IBOutlet weak var sharedView: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .Image {
                let image = UIImage.imageFromBase64String(data.value!.stringValue)
                self?.imageReceived(image, fromPeer: peer)
            }
        }
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
//            cameraController.cameraEngine.blockCompletionBuffer = { [weak self] buffer in
//                self?.sendPreviewToPeers(buffer)
//            }
        }
    }
    
    func imageReceived(image: UIImage, fromPeer peer: MCPeerID) {
        imageReceived[peer] = image
        mergeImagesIfFinshed()
    }
    
    func mergeImagesIfFinshed() {
        guard let imageTaken = imageTaken else {
            return
        }
        guard imageReceived.count == peers.count else {
            return
        }
        var images = [imageTaken]
        for peer in peers {
            if let image = imageReceived[peer] {
                images.append(image)
            }
        }
        
        let data = Data(command: .Result, value: JSON(images.map({ $0.toBase64String() })))
        session.sendData(data, toPeers: peers)
        Async.main(after: 0.6) {
            self.displayVC.images = images
        }
    }
    
    func sendPreviewToPeers(buffer: CMSampleBuffer) {
        let time = NSDate().timeIntervalSince1970
        if time - lastSyncTime < 0.2 {
            return
        }
        
        let image = sampleBufferToImage(buffer).cropCenterSquare().resize(toSize: 300)
        let finalImage = UIImage(CGImage: image.CGImage!,
                                 scale: 1.0 ,
                                 orientation: UIImageOrientation.Right)
        let data = Data(command: .Preview, value: JSON(finalImage.toBase64String()))
        session.sendData(data, toPeers: self.peers, withMode: .Unreliable)
        lastSyncTime = time
    }

    
    @IBAction func shootButtonPressed(sender: AnyObject) {
        let data = Data(command: .Shoot)
        session.sendData(data, toPeers: peers)
        cameraController.shoot { [weak self] image in
            guard let this = self else {
                return
            }
            this.imageTaken = image
            this.displayVC = R.storyboard.shoot.display()!
            this.navigationController?.pushViewController(this.displayVC, animated: true)
            this.mergeImagesIfFinshed()
        }

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
