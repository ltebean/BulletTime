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

    @IBOutlet weak var sharedView: UIButton!
    @IBOutlet weak var centralPreviewView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session.delegate = sessionDelegate
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .Shoot {
                self?.shoot()
            }
            else if command == .Preview {
                let image = UIImage.imageFromBase64String(data.value!.stringValue)
                self?.showCentralPreview(image)
            }

            else if command == .Result {
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
        }
    }
    
    func showCentralPreview(image: UIImage) {
        centralPreviewView.image = image
        centralPreviewView.alpha = 0.4

    }
    
    func showResult(images: [UIImage]) {
        displayVC.images = images
    }

    func shoot() {
        if navigationController?.topViewController != self {
            navigationController?.popToViewController(self, animated: false)
        }
//        cameraController.shoot { image in
//            self.displayVC = R.storyboard.shoot.display()!
//            self.navigationController?.pushViewController(self.displayVC, animated: true)
//            self.sendImageToCentral(image.cropCenterSquare())
//        }


        displayVC = R.storyboard.shoot.display()!
        navigationController?.pushViewController(displayVC, animated: true)
        self.sendImageToCentral(R.image.test1()!.cropCenterSquare())
    }
    
    func sendImageToCentral(image: UIImage) {
        let data = Data(command: .Image, value: JSON(image.toBase64String()))
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
