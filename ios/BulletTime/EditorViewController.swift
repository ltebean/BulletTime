//
//  EditorViewController.swift
//  BulletTime
//
//  Created by ltebean on 8/28/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Async
import SwiftyJSON

class EditorViewController: UIViewController {
    
    var displayVC: DisplayViewController!

    var peer: MCPeerID!
    var session : MCSession! {
        didSet {
            session.delegate = sessionDelegate
        }
    }
    var videoEndTime: Float64 = 0
    var peers: [MCPeerID] = []
    var imageReceived: [MCPeerID: UIImage] = [:]
    var imageTaken: UIImage?
    let sessionDelegate = SessionDelegate()

    
    var videoURL: NSURL!
    
    private var playerLayer: AVPlayerLayer!
    private var player: AVPlayer!
    private var playerItem: AVPlayerItem!
    private var asset: AVAsset!

    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        asset = AVAsset(URL: videoURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerView.layer.insertSublayer(playerLayer, atIndex: 0)
        
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .PeerImage {
                let image = UIImage.imageFromBase64String(data.value!.stringValue)
                self?.imageReceived(image, fromPeer: peer)
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        player.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
        imageTaken = nil
        imageReceived = [:]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.bounds
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
        
        let data = Data(command: .FinalResult, value: JSON(images.map({ $0.toBase64String() })))
        session.sendData(data, toPeers: peers)
        Async.main(after: 0.6) {
            self.displayVC.images = images
        }
    }
    
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let time = calculateCurrentTime()
        player.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)

    }
    
    func calculateCurrentTime() -> CMTime {
        let progress = Float64(slider.value)
        let totalSeconds = CMTimeGetSeconds(asset.duration)
        let seconds = totalSeconds * progress
        return CMTimeMakeWithSeconds(seconds, asset.duration.timescale)
    }
    
    @IBAction func next(sender: AnyObject) {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = calculateCurrentTime()
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.appliesPreferredTrackTransform = true

        imageGenerator.generateCGImagesAsynchronouslyForTimes([NSValue(CMTime: time)]) { (requestedTime, image, actualTime, result, error) in
            if let image = image {
                Async.main {
                    self.imageTaken = UIImage(CGImage: image).cropCenterSquare()
                }
            }
            
        }
        
        let data = Data(command: .UseFrame, value: [
            "time": String(format:"%.8f", (videoEndTime - CMTimeGetSeconds(asset.duration) + CMTimeGetSeconds(time)))
        ])
        session.sendData(data, toPeers: peers)

        
        displayVC = R.storyboard.shoot.display()!
        self.navigationController?.presentViewController(displayVC, animated: true, completion: nil)
    }
    
}

extension EditorViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return nil
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return UIColor.whiteColor()
    }
}
