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
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var turnOnView: UIView!
    
    var bluetoothManager: CBPeripheralManager!

    var transitionDelegate: ViewTransitionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        transitionDelegate = ViewTransitionDelegate(navigationController: navigationController!)
        navigationController?.delegate = transitionDelegate
        
        let options = [CBCentralManagerOptionShowPowerAlertKey: 0]
        bluetoothManager = CBPeripheralManager(delegate: self, queue: nil, options: options)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.showTab()
        }, completion: nil)
        Host.reset()
        Guest.reset()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTab()
    }
    
    @IBAction func appButtonPressed(_ sender: AnyObject) {
        Share.shareURL(URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1178860612&mt=8")!, inViewController: self)
    }

    @IBAction func instagramTagButtonPressed(_ sender: AnyObject) {
        let url = URL(string: "instagram://tag?name=Friizit")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            let alertController = UIAlertController(title: "Instagram not installed", message: nil, preferredStyle: .alert)
            let no = UIAlertAction(title: "ok", style: .cancel) { action in }
            alertController.addAction(no)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonHostPressed(_ sender: AnyObject) {
        hideHomeTab()
        push(R.storyboard.shoot.discoveries()!)
    }
    
    @IBAction func buttonGeustPressed(_ sender: AnyObject) {
        hideHomeTab()
        push(R.storyboard.shoot.broadcast()!)
    }
    
    @IBAction func turnOnBluetoothButtonPressed(_ sender: AnyObject) {
        let url = URL(string: "prefs:root=Bluetooth")!
        UIApplication.shared.openURL(url)
    }
    
    func hideHomeTab() {
        UIView.animate(withDuration: 0.35, animations: {
            self.hideTab()
        })
    }
    
}

extension RoleSelectionViewController: AnimatableViewController {
    
    func viewsToAnimate() -> [UIView] {
        return [mainView, buttonHost, buttonGuest]
    }

}

extension RoleSelectionViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        var statusMessage = ""
        
        switch peripheral.state {
        case .poweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            turnOnView.isHidden = true
            
        case .poweredOff:
            statusMessage = "Bluetooth Status: Turned Off"
            
        case .resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case .unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case .unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
        }
        print(statusMessage)
    }
    
}

