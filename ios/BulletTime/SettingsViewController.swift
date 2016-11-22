//
//  SettingsViewController.swift
//  BulletTime
//
//  Created by leo on 16/8/23.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBAction func buttonBackPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = (indexPath as NSIndexPath).row
        if row == 0 {
            shareApp()
        }
        else if row == 1 {
            rateApp()
        }
        else if row == 2 {
            sendFeedback()
        }
        
    }
    
    @IBAction func goToLackarPage(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "http://lackar.com/")!)
    }
    
    @IBAction func goToLeoPage(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://github.com/ltebean")!)
    }
    
    
    func shareApp() {
        Share.shareURL(URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1178860612&mt=8")!, inViewController: self)
    }
    
    func rateApp() {
        guard let url = URL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1178860612&onlyLatestVersion=true&type=Purple+Software") else {
            return
        }
        UIApplication.shared.openURL(url);
    }
    
    func sendFeedback() {
        guard let url = URL(string:"mailto:yucong1118@gmail.com") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}
