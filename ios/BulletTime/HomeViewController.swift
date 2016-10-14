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
        homeVC.tab.isHidden = false
    }
    
    func hideTab() {
        homeVC.tab.alpha = 0
    }
    
    func removeTab() {
        homeVC.tab.isHidden = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "me" {
            meVC = segue.destination as! MeViewController
            meVC.homeVC = self
        } else if segue.identifier == "shoot" {
            roleVC = (segue.destination as! UINavigationController).topViewController as! RoleSelectionViewController
            roleVC.homeVC = self
        }
    }
    
    
    @IBAction func buttonShootPressed(_ sender: AnyObject) {
        roleVC.refresh()
        roleView.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.meView.alpha = 0
            self.buttonMe.backgroundColor = UIColor.black.withAlphaComponent(0.15)

        }, completion: { finished in
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                self.buttonShoot.backgroundColor = UIColor.black
                self.roleView.alpha = 1
            }, completion: { finished in
                self.view.sendSubview(toBack: self.meView)
            })
        })
    }

    @IBAction func buttonMePressed(_ sender: AnyObject) {
        meVC.refresh()
        meView.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.roleView.alpha = 0
            self.buttonShoot.backgroundColor = UIColor.black.withAlphaComponent(0.15)

        }, completion: { finished in
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                self.buttonMe.backgroundColor = UIColor.black
                self.meView.alpha = 1
            }, completion: { finished in
                self.view.sendSubview(toBack: self.roleView)
            })
        })
    }
    

}

