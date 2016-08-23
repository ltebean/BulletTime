//
//  ViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/29/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit

class RoleSelectionViewController: HomeChildViewController {
    
    enum State {
        case Host
        case Guest
        case None
    }
    
    @IBOutlet weak var buttonHost: DesignableButton!
    @IBOutlet weak var buttonGuest: DesignableButton!
    @IBOutlet weak var buttonSpacing: NSLayoutConstraint!
    
    
    var state = State.None
    
    var transitionDelegate: TransitionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonSpacing.constant = 0
        transitionDelegate = TransitionDelegate(navigationController: navigationController!)
        navigationController?.delegate = transitionDelegate
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.1, animations: {
//            self.buttonHost.alpha = 1
//            self.buttonGuest.alpha = 1
            self.showTab()
        }, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeTab()
    }

    @IBAction func buttonHostPressed(sender: AnyObject) {
        state = .Host
        next()
    }
    
    @IBAction func buttonGeustPressed(sender: AnyObject) {
        state = .Guest
        next()
    }
    
    
    func next() {
        self.removeTab()
        if state == .Host {
            let vc = R.storyboard.shoot.discoveries()!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if state == .Guest {
            let vc = R.storyboard.shoot.broadcast()!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}

extension RoleSelectionViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return nil
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return nil
    }

}

