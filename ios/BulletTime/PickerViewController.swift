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

    let pickerWidth = 260
    let pickerHeight = 70
    let bgViewCenterX = 260 / 2 - 70 / 2
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
        buttonNext.hidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PickerViewController.tapped(_:)))
        pickerView.addGestureRecognizer(tap)
        
        host.onAllPeerImageReceived = { [weak self] images in
            self?.allImageReceived(images)
        }
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        host.resetImageReceived()
        imageView.image = images[currentIndex]
    }
    
    func tapped(gesture: UITapGestureRecognizer) {
        guard gesture.state == .Ended else {
            return
        }
        buttonNext.hidden = true
        let x = Int(gesture.locationInView(gesture.view).x)
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
        UIView.animateWithDuration(0.1, animations: {
            self.bgCenter.constant = CGFloat(center)
            self.pickerView.layoutIfNeeded()
        })
        showNextButton()
    }
    
    func showNextButton() {
        buttonNext.hidden = false
        buttonNext.alpha = 0
        UIView.animateWithDuration(0.2, delay: 0.4, options: [], animations: {
            self.buttonNext.alpha = 1
        }, completion: nil)

    }
    

    
    func allImageReceived(images: [UIImage]) {
        var result = [imageTaken]
        result.appendContentsOf(images)
        host.sendFinalResult(result)
        Async.main(after: 0.8) {
            self.displayVC.images = result
        }
    }
    
    
    @IBAction func buttonNextPressed(sender: AnyObject) {
        host.sendUseFrame(atTime: times[currentIndex])
        next()
    }
    
    func next() {
        if host.peersToNotify.count == 0 {
            allImageReceived([])
        }
        displayVC = R.storyboard.shoot.display()!
        navigationController?.pushViewController(displayVC, animated: true)
    }
    
}

extension PickerViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return nil
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return UIColor.blackColor()
    }
}
