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
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeTab()
    }

    @IBAction func buttonHostPressed(sender: AnyObject) {
        Host.reset()
        let vc = R.storyboard.shoot.discoveries()!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonGeustPressed(sender: AnyObject) {
        let vc = R.storyboard.shoot.broadcast()!
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension RoleSelectionViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        var statusMessage = ""
        
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            
        case CBPeripheralManagerState.PoweredOff:
            statusMessage = "Bluetooth Status: Turned Off"
            
        case CBPeripheralManagerState.Resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case CBPeripheralManagerState.Unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case CBPeripheralManagerState.Unsupported:
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

