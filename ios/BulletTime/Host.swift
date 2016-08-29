//
//  Host.swift
//  BulletTime
//
//  Created by leo on 16/8/29.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import SwiftyJSON

class Host: NSObject {
    
    static var current: Host!
    
    let central = MCPeerID(displayName: UIDevice.currentDevice().name)
    let sessionDelegate = SessionDelegate()

    var serviceBrowser: MCNearbyServiceBrowser!
    var session: MCSession!
    var allPeers = [MCPeerID]()
    var peersToNotify: [MCPeerID] {
        return allPeers.filter({ $0 != central })
    }
    var imageReceived: [MCPeerID: UIImage] = [:]

    
    var onPeerJoin: ((peer: MCPeerID) -> ())?
    var onPeerLost: ((peer: MCPeerID, index: Int) -> ())?
    var onAllPeerImageReceived: ((images: [UIImage]) -> ())?
    
    func setup() {
        serviceBrowser = MCNearbyServiceBrowser(peer: central, serviceType: "bullettime")
        serviceBrowser.delegate = self
        session = MCSession(peer: central, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session.delegate = sessionDelegate
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .PeerReady {
                self?.peerJoined(peer)
            }
            else if command == .PeerImage {
                let image = UIImage.imageFromBase64String(data.value!.stringValue)
                self?.peerImageReceived(image, fromPeer: peer)
            }
        }
        allPeers = [central]
    }
    
    // MARK: public
    func startBrowsing() {
        serviceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func resetImageReceived() {
        imageReceived = [:]
    }
    
    // MARK: send signal
    func sendStartRecording() {
        let data = Data(command: .StartRecording)
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendStopRecording() {
        let data = Data(command: .StopRecording)
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendFinalResult(images: [UIImage]) {
        let data = Data(command: .FinalResult, value: JSON(images))
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendUseFrame(atTime time: Float64) {
        let data = Data(command: .UseFrame, value: [
            "time": String(format:"%.8f", time)
        ])
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendPeersUpdates() {
        let count = "\(allPeers.count)"
        for peer in peersToNotify {
            let index = "\(allPeers.indexOf(peer)!)"
            let data = Data(command: .PeersUpdates, value: JSON([
                "count": count,
                "index": index
            ]))
            session.sendData(data, toPeers: [peer])
        }
    }
    
     // MARK: event handler
    private func peerJoined(peer: MCPeerID) {
        guard allPeers.indexOf(peer) == nil else {
            return
        }
        allPeers.append(peer)
        sendPeersUpdates()
        onPeerJoin?(peer: peer)
    }

    private func peerLost(peer: MCPeerID) {
        guard let index = allPeers.indexOf(peer) else {
            return
        }
        allPeers.removeAtIndex(index)
        sendPeersUpdates()
        onPeerLost?(peer: peer, index: index)
    }
    
    private func peerImageReceived(image: UIImage, fromPeer peer: MCPeerID) {
        imageReceived[peer] = image
        guard imageReceived.count == peersToNotify.count else {
            return
        }
        var images = [UIImage]()
        for peer in peersToNotify {
            if let image = imageReceived[peer] {
                images.append(image)
            }
        }
        onAllPeerImageReceived?(images: images)
    }
    

    // MARK: life cycle
    static func reset() {
        current = Host()
        current.setup()
    }
    
    deinit {
        serviceBrowser.stopBrowsingForPeers()
    }
}

extension Host: MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let _ = allPeers.indexOf(peerID) {
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