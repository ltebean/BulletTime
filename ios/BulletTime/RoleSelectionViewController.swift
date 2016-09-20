//
//  ViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/29/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import CoreBluetooth

class RoleSelectionViewController: HomeChildViewController {
    
    @IBOutlet weak var buttonHost: DesignableButton!
    @IBOutlet weak var buttonGuest: DesignableButton!
    @IBOutlet weak var buttonSpacing: NSLayoutConstraint!
    
    
    var bluetoothManager: CBPeripheralManager!

    var transitionDelegate: TransitionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonSpacing.constant = 0
        transitionDelegate = TransitionDelegate(navigationController: navigationController!)
        navigationController?.delegate = transitionDelegate
        
        let options = [CBCentralManagerOptionShowPowerAlertKey: 0]
        bluetoothManager = CBPeripheralManager(delegate: self, queue: nil, options: options)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.1, animations: {
            self.showTab()
        }, completion: nil)
        Host.reset()
        Guest.reset()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeTab()
    }

    @IBAction func buttonHostPressed(sender: AnyObject) {
        push(R.storyboard.shoot.discoveries()!)
    }
    
    @IBAction func buttonGeustPressed(sender: AnyObject) {
        push(R.storyboard.shoot.broadcast()!)
    }
    

}

extension RoleSelectionViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        var statusMessage = ""
        
        switch peripheral.state {
        case .PoweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            
        case .PoweredOff:
            statusMessage = "Bluetooth Status: Turned Off"
            
        case .Resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case .Unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case .Unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
        }
        print(statusMessage)
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

