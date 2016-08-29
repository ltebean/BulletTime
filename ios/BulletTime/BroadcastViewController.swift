//
//  BroadcastViewController.swift
//  BulletTime
//
//  Created by ltebean on 8/13/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SwiftyJSON

class BroadcastViewController: UIViewController {
    
    let peer = MCPeerID(displayName: UIDevice.currentDevice().name)
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    var session : MCSession!
    var centralPeer: MCPeerID!
    let sessionDelegate = SessionDelegate()
    var peersCount = 0
    var index = 0
    
    @IBOutlet weak var circleView: LTCircleView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.dataSource = self
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "bullettime")
        serviceAdvertiser.delegate = self
        session = MCSession(peer: peer)
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .PeersUpdates {
                self?.updatePeersInfo(withData: data.value!)
            }
            
        }
        sessionDelegate.stateChanged = { [weak self] state in
            if state == .Connected {
                self?.sendReadySignal()
            }
            else if state == .NotConnected {
                self?.showEmptyView()
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showConnecting()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        session.delegate = sessionDelegate
        serviceAdvertiser.startAdvertisingPeer()
        sendReadySignal()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func showConnecting() {
        peersCount = 0
        circleView.reloadData()
        statusLabel.text = "Connecting..."
    }
    
    func showEmptyView() {
        peersCount = 0
        circleView.reloadData()
        statusLabel.text = "Disconnected"
    }
    
    func sendReadySignal() {
        if centralPeer != nil {
            session.sendData(Data(command: .PeerReady), toPeers: [centralPeer])
        }
    }
    
    func updatePeersInfo(withData data: JSON) {
        peersCount = data["count"].intValue
        index = data["index"].intValue
        circleView.reloadData()
        statusLabel.text = "Your position is \(index + 1)"
    }

    
    @IBAction func buttonNextPressed(sender: AnyObject) {
        let vc = R.storyboard.shoot.peripheral()!
        vc.session = session
        vc.centralPeer = centralPeer
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

extension BroadcastViewController: LTCircleViewDataSource {
    
    func numberOfItemsInCircleView(circleView: LTCircleView) -> Int {
        return peersCount
    }
    
    func viewAtIndex(index: Int, inCircleView circleView: LTCircleView) -> UIView {
        let bubble = BubbleView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        bubble.color = UIColor.steppedColor(fromHex: BubbleView.startColorHex, endHex: BubbleView.endColorHex, totalCount: peersCount, index: index)
        bubble.text = "\(index + 1)"
        if (index == self.index) {
            bubble.showHalo()
        }
        return bubble
    }
}

extension BroadcastViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        centralPeer = peerID
        invitationHandler(true, session)
    }
    
    internal func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
}

extension BroadcastViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return buttonNext
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return nil
    }
}
