//
//  PickerViewController.swift
//  BulletTime
//
//  Created by ltebean on 9/3/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import Async

class PickerViewController: UIViewController {

    var times: [Float64] = []
    var images: [UIImage]!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonNext: DesignableButton!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var bgView: DesignableView!
    @IBOutlet weak var bgCenter: NSLayoutConstraint!
    
    let host = Host.current

    let pickerWidth = 280
    let pickerHeight = 80
    let bgViewCenterX = 280 / 2 - 80 / 2
    var currentIndex = 1 {
        didSet {
            imageView.image = images[currentIndex]
        }
    }
    var imageTaken: UIImage {
        return images[currentIndex]
    }
    
    var displayVC: DisplayViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonNext.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PickerViewController.tapped(_:)))
        pickerView.addGestureRecognizer(tap)
        
        host?.onAllPeerImageReceived = { [weak self] images in
            self?.allImageReceived(images)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        host?.resetImageReceived()
        imageView.image = images[currentIndex]
    }
    
    func tapped(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        buttonNext.isHidden = true
        let x = Int(gesture.location(in: gesture.view).x)
        var center = 0
        if x < (pickerWidth / 3) {
            currentIndex = 0
            center = -bgViewCenterX
        } else if x < (pickerWidth / 3 * 2) {
            currentIndex = 1
            center = 0
        } else {
            currentIndex = 2
            center = bgViewCenterX
        }
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
            self.bgCenter.constant = CGFloat(center)
            self.pickerView.layoutIfNeeded()
        }, completion: nil)
        showNextButton()
    }
    
    func showNextButton() {
        buttonNext.isHidden = false
        buttonNext.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.4, options: [.curveEaseOut], animations: {
            self.buttonNext.alpha = 1
        }, completion: nil)

    }
    

    
    func allImageReceived(_ images: [UIImage]) {
        var result = [imageTaken]
        result.append(contentsOf: images)
        host?.sendFinalResult(result)
        Async.main(after: 0.8) {
            self.displayVC.images = result
        }
    }
    
    
    @IBAction func buttonNextPressed(_ sender: AnyObject) {
        host?.sendUseFrame(atTime: times[currentIndex])
        next()
    }
    
    @IBAction func back(_ sender: AnyObject) {
        pop()
    }
    
    func next() {
        if host?.peersToNotify.count == 0 {
            allImageReceived([])
        }
        displayVC = R.storyboard.shoot.display()!
        push(displayVC)
    }
    
    
}

extension PickerViewController: AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return view.subviews
    }
    
    func backgroundColor() -> UIColor {
        return UIColor.black
    }
}
