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
    private var playerObserver: AnyObject?

    let host = Host.current
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var slider: UISlider!
    
    var seeking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        asset = AVAsset(URL: videoURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerView.layer.insertSublayer(playerLayer, atIndex: 0)
        
        progressLabel.alpha = 0

        host.onAllPeerImageReceived = { [weak self] images in
            self?.allImageReceived(images)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: playerItem, queue: nil) { [weak self]notification in
            self?.player.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            self?.player.play()
        }
        
        let pan = PanDirectionGestureRecognizer(direction: .Horizontal ,target: self, action: #selector(EditorViewController.handlePan(_:)))
        playerView.addGestureRecognizer(pan)
        
        player.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player.play()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        imageTaken = nil
        host.resetImageReceived()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.bounds
    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Began {
            player.pause()
            UIView.animateWithDuration(0.1, animations: {
                self.progressLabel.alpha = 1
            })
        }
        else if gesture.state == .Ended {
            UIView.animateWithDuration(0.1, animations: {
                self.progressLabel.alpha = 0
            })
        }
        else if gesture.state == .Changed {
            guard !seeking else {
                return
            }
            seeking = true
            let totalSeconds = CMTimeGetSeconds(asset.duration)
            let secondsPerPoint = totalSeconds / Float64(UIScreen.mainScreen().bounds.width)
            let tx = gesture.translationInView(gesture.view).x
            let currentSeconds = CMTimeGetSeconds(playerItem.currentTime())
            let targetSeconds = currentSeconds + Float64(tx) * secondsPerPoint
            player.seekToTime(CMTimeMakeWithSeconds(targetSeconds, asset.duration.timescale), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: {_ in 
                Async.main {
                    self.seeking = false
                }
            })
            gesture.setTranslation(CGPointZero, inView: gesture.view)
            var progress = Int(targetSeconds / totalSeconds * 100)
            progress = min(progress, 100)
            progress = max(progress, 0)
            progressLabel.text = "\(progress)%"
        }
    }
    
    func allImageReceived(images: [UIImage]) {
        var result = [imageTaken!]
        result.appendContentsOf(images)
        host.sendFinalResult(result)
        Async.main(after: 0.8) {
            self.displayVC.images = result
        }
    }
    
    
//    @IBAction func sliderValueChanged(sender: UISlider) {
//        let time = calculateCurrentTime()
//        player.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
//    }
//    
//    func calculateCurrentTime() -> CMTime {
//        let progress = Float64(slider.value)
//        let totalSeconds = CMTimeGetSeconds(asset.duration)
//        let seconds = totalSeconds * progress
//        return CMTimeMakeWithSeconds(seconds, asset.duration.timescale)
//    }
    
    @IBAction func next(sender: AnyObject) {
        let time = playerItem.currentTime()
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
        push(displayVC)
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
