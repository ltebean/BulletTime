//
//  MainViewController.swift
//  BulletTime
//
//  Created by leo on 16/8/17.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class HomeChildViewController: UIViewController {
    
    weak var homeVC: HomeViewController!
    
    func showTab() {
        homeVC.tab.alpha = 1
        homeVC.tab.hidden = false
    }
    
    func hideTab() {
        homeVC.tab.alpha = 0
    }
    
    func removeTab() {
        homeVC.tab.hidden = true
    }
    
    func refresh() {
        
    }
}


class HomeViewController: UIViewController {
    
    let animationDuration = 0.35

    @IBOutlet weak var tab: UIView!
    
    @IBOutlet weak var tabBackgroundLeft: NSLayoutConstraint!
    @IBOutlet weak var buttonShoot: UIButton!
    @IBOutlet weak var buttonMe: UIButton!
    
    @IBOutlet weak var meView: UIView!
    @IBOutlet weak var roleView: UIView!
    
    var roleVC: RoleSelectionViewController!
    var meVC: MeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "me" {
            meVC = segue.destinationViewController as! MeViewController
            meVC.homeVC = self
        } else if segue.identifier == "shoot" {
            roleVC = (segue.destinationViewController as! UINavigationController).topViewController as! RoleSelectionViewController
            roleVC.homeVC = self
        }
    }
    
    
    @IBAction func buttonShootPressed(sender: AnyObject) {
        roleVC.refresh()
        roleView.alpha = 0
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.CurveEaseOut], animations: {
            self.meView.alpha = 0
            self.buttonMe.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)

        }, completion: { finished in
            UIView.animateWithDuration(self.animationDuration, delay: 0, options: [.CurveEaseOut], animations: {
                self.buttonShoot.backgroundColor = UIColor.blackColor()
                self.roleView.alpha = 1
            }, completion: { finished in
                self.view.sendSubviewToBack(self.meView)
            })
        })
    }

    @IBAction func buttonMePressed(sender: AnyObject) {
        meVC.refresh()
        meView.alpha = 0
        UIView.animateWithDuration(animationDuration, delay: 0, options: [.CurveEaseOut], animations: {
            self.roleView.alpha = 0
            self.buttonShoot.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)

        }, completion: { finished in
            UIView.animateWithDuration(self.animationDuration, delay: 0, options: [.CurveEaseOut], animations: {
                self.buttonMe.backgroundColor = UIColor.blackColor()
                self.meView.alpha = 1
            }, completion: { finished in
                self.view.sendSubviewToBack(self.roleView)
            })
        })
    }
    

}

