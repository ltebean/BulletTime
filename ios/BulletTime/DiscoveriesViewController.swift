//
//  PeripheralListViewController.swift
//  BulletTime
//
//  Created by ltebean on 7/30/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SwiftyJSON

class DiscoveriesViewController: UIViewController {

    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var circleView: LTCircleView!
    
    var serviceBrowser: MCNearbyServiceBrowser!
    var session: MCSession!
    var peers = [MCPeerID]()
    var peersToNotify: [MCPeerID] {
        return peers.filter({ $0 != peer })
    }
    var peer: MCPeerID!
    
    let sessionDelegate = SessionDelegate()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        peer = MCPeerID(displayName: UIDevice.currentDevice().name)
        serviceBrowser = MCNearbyServiceBrowser(peer: peer, serviceType: "bullettime")
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .Ready {
                self?.peerJoined(peer)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.dataSource = self
        serviceBrowser.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        peers = [peer]
        peers.appendContentsOf(session.connectedPeers)
        circleView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        session.delegate = sessionDelegate
        serviceBrowser.startBrowsingForPeers()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func peerJoined(peer: MCPeerID) {
        guard peers.indexOf(peer) == nil else {
            sendPeersUpdates()
            return
        }
        peers.append(peer)
        circleView.insertItemAtIndex(peers.count - 1)
        sendPeersUpdates()
    }
    
    func peerLost(peer: MCPeerID) {
        guard let index = peers.indexOf(peer) else {
            return
        }
        peers.removeAtIndex(index)
        circleView.removeItemAtIndex(index)
        sendPeersUpdates()
    }
    
    func sendPeersUpdates() {
        let count = "\(peers.count)"
        for peer in peersToNotify {
            let index = "\(peers.indexOf(peer)!)"
            let data = Data(command: .PeersUpdates, value: JSON([
                "count": count,
                "index": index
            ]))
            session.sendData(data, toPeers: [peer])
        }
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func buttonNextPressed(sender: AnyObject) {
        
        let vc = R.storyboard.shoot.central()!
        vc.session = session
        vc.peer = peer
        vc.peers = peersToNotify
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension DiscoveriesViewController: MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let _ = peers.indexOf(peerID) {
            return
        }
        serviceBrowser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 30)
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peerLost(peerID)
    }
    

    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        
    }
    
}

extension DiscoveriesViewController: LTCircleViewDataSource {
    
    func numberOfItemsInCircleView(circleView: LTCircleView) -> Int {
        return peers.count
    }
    
    func viewAtIndex(index: Int, inCircleView circleView: LTCircleView) -> UIView {
        let bubble = BubbleView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        bubble.text = "\(index + 1)"
        bubble.color = UIColor.steppedColor(fromHex: BubbleView.startColorHex, endHex: BubbleView.endColorHex, totalCount: peers.count, index: index)
        if (index == 0) {
            bubble.showHalo()
        }
        return bubble
    }
}

extension DiscoveriesViewController: SharedViewTransition {
    
    func sharedView(isPush isPush: Bool) -> UIView? {
        return buttonNext
    }
    
    func requiredBackgroundColor() -> UIColor? {
        return nil
    }
}
