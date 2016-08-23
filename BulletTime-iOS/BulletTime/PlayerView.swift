//
//  PlayerView.swift
//  BulletTime
//
//  Created by leo on 16/8/5.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    
    private var images: [UIImage] = []
    private var imageView: UIImageView!
    private var spinner: UIActivityIndicatorView!

    private var currentIndex = 0
    
    private var timer: NSTimer!
    private var dragging = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        imageView = UIImageView(frame: bounds)
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.backgroundColor = UIColor(hex: 0xcccccc)
        addSubview(imageView)
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        addSubview(spinner)
        spinner.startAnimating()
        
        let pan = PanDirectionGestureRecognizer(direction: .Horizontal, target: self, action: #selector(PlayerView.handlePan(_:)))
        addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    func reload(withImages images:[UIImage]) {
        self.images = images
        imageView.image = images[0]
        currentIndex = 0
        resetTimer()
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    func resetTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(PlayerView.tick(_:)), userInfo: nil, repeats: true)
    }
    
    func tick(timer: NSTimer) {
        guard !dragging else {
            return
        }
        let index = (currentIndex < images.count - 1) ? currentIndex + 1 : 0
        imageView.image = images[index]
        currentIndex = index
    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .Began {
            dragging = true
        }
        else if gesture.state == .Changed {
            let tx = gesture.translationInView(self).x
            if fabs(tx) > 30 {
                tx > 0 ? showNext() : showPrevious()
                gesture.setTranslation(CGPointZero, inView: self)
            }
        }
        else if gesture.state == .Ended {
            dragging = false
        }
    }
    
    func showNext() {
        let index = currentIndex + 1
        guard index < images.count else {
            return
        }
        imageView.image = images[index]
        currentIndex = index
    }
    
    func showPrevious() {
        let index = currentIndex - 1
        guard index >= 0 else {
            return
        }
        imageView.image = images[index]
        currentIndex = index
    }
    
    deinit {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    
}

