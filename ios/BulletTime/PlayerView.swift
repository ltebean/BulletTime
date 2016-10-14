//
//  PlayerView.swift
//  BulletTime
//
//  Created by leo on 16/8/5.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    
    fileprivate var images: [UIImage] = []
    fileprivate var imageView: UIImageView!
    fileprivate var spinner: UIActivityIndicatorView!

    fileprivate var currentIndex = 0
    
    fileprivate var timer: Timer!
    fileprivate var dragging = false
    
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
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.backgroundColor = UIColor(hex: 0xcccccc)
        addSubview(imageView)
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        addSubview(spinner)
        spinner.startAnimating()
        
        let pan = PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(PlayerView.handlePan(_:)))
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
        timer = Timer.scheduledTimer(timeInterval: Config.frameInterval, target: self, selector: #selector(PlayerView.tick(_:)), userInfo: nil, repeats: true)
    }
    
    func tick(_ timer: Timer) {
        guard !dragging else {
            return
        }
        let index = (currentIndex < images.count - 1) ? currentIndex + 1 : 0
        imageView.image = images[index]
        currentIndex = index
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            dragging = true
        }
        else if gesture.state == .changed {
            let tx = gesture.translation(in: self).x
            if fabs(tx) > 30 {
                tx > 0 ? showNext() : showPrevious()
                gesture.setTranslation(CGPoint.zero, in: self)
            }
        }
        else if gesture.state == .ended {
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

