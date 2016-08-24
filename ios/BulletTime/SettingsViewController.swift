//
//  SettingsViewController.swift
//  BulletTime
//
//  Created by leo on 16/8/23.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBAction func buttonBackPressed(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
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
    
    func shareApp() {
        
    }
    
    func rateApp() {
        
    }
    
    func sendFeedback() {
        
    }
}
