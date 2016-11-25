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
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var meView: UIView!
    @IBOutlet weak var roleView: UIView!
    
    var roleVC: RoleSelectionViewController!
    var meVC: MeViewController!
    var isRoleTab = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tabButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
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
    
    @IBAction func tabButtonPressed(_ sender: Any) {
        if isRoleTab {
            goToAlbum()
        } else {
            goToRole()
        }
        isRoleTab = !isRoleTab
    }
    
    func goToRole() {
        roleVC.refresh()
        roleView.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.meView.alpha = 0
            self.tabButton.alpha = 0
        }, completion: { finished in
            self.tabButton.setImage(R.image.tabAlbum()!, for: .normal)

            UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                self.roleView.alpha = 1
                self.tabButton.alpha = 1
            }, completion: { finished in
                self.view.sendSubview(toBack: self.meView)
            })
        })
    }

    func goToAlbum() {
        meVC.refresh()
        meView.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.roleView.alpha = 0
            self.tabButton.alpha = 0
        }, completion: { finished in
            self.tabButton.setImage(R.image.tabShoot()!, for: .normal)

            UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.curveEaseOut], animations: {
                self.meView.alpha = 1
                self.tabButton.alpha = 1

            }, completion: { finished in
                self.view.sendSubview(toBack: self.roleView)
            })
        })
    }
    

}

