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
        
    }
    
    func rateApp() {
        
    }
    
    func sendFeedback() {
        
    }
}
