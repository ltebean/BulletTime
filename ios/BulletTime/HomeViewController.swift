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
    
    func setTabScrollEnabled(enabled: Bool) {
        homeVC.scrollView.scrollEnabled = enabled
    }
    
    func refresh() {
        
    }
}


class HomeViewController: UIViewController {

    @IBOutlet weak var tab: UIView!
    
    @IBOutlet weak var tabBackgroundLeft: NSLayoutConstraint!
    @IBOutlet weak var buttonShoot: UIButton!
    @IBOutlet weak var buttonMe: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var vcs = [HomeChildViewController]()
    let pageWidth = Int(UIScreen.mainScreen().bounds.width)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.scrollEnabled = false
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        
        for vc in childViewControllers {
            if let vc = vc as? UINavigationController {
                let childVC = (vc.topViewController as! HomeChildViewController)
                childVC.homeVC = self
                vcs.append(childVC)

            } else {
                let childVC = (vc as! HomeChildViewController)
                childVC.homeVC = self
                vcs.append(childVC)
            }
        }
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: (page * pageWidth), y: 0), animated: animated)
    }


    @IBAction func buttonShootPressed(sender: AnyObject) {
        scrollToPage(0, animated: true)
    }

    @IBAction func buttonMePressed(sender: AnyObject) {
        scrollToPage(1, animated: true)
        vcs[1].refresh()
    }
    

}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let tx = scrollView.contentOffset.x
        let width = UIScreen.mainScreen().bounds.width
        
        let progress = tx / width
        
        tabBackgroundLeft.constant = progress * tab.bounds.width / 2
    }
}
