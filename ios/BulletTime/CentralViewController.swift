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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "camera" {
            cameraController = segue.destinationViewController as! CameraViewController
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
}


extension CentralViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return sharedView
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return UIColor.blackColor()
    }
}
