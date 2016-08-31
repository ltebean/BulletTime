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
    var videoEndTime: Float64 = 0
    var videoURL: NSURL!
    var imageTaken: UIImage?
    
    private var playerLayer: AVPlayerLayer!
    private var player: AVPlayer!
    private var playerItem: AVPlayerItem!
    private var asset: AVAsset!
    
    let host = Host.current
    
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
        
        host.onAllPeerImageReceived = { [weak self] images in
            self?.allImageReceived(images)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        player.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        imageTaken = nil
        host.resetImageReceived()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.bounds
    }
    
    func allImageReceived(images: [UIImage]) {
        var result = [imageTaken!]
        result.appendContentsOf(images)
        host.sendFinalResult(result)
        Async.main(after: 0.8) {
            self.displayVC.images = result
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
        let time = calculateCurrentTime()
        let absoluteTime = (videoEndTime - CMTimeGetSeconds(asset.duration) + CMTimeGetSeconds(time))
        asset.generateImageAtTime(time, completion: { image in
            if let image = image {
                self.imageTaken = image
                self.host.sendUseFrame(atTime: absoluteTime)
                self.next()
            } else {
                
            }
        })
    }
    
    func next() {
        if host.peersToNotify.count == 0 {
            allImageReceived([])
        }
        displayVC = R.storyboard.shoot.display()!
        navigationController?.pushViewController(displayVC, animated: true)
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
