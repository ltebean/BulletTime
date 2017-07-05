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
    
    private static var shared: Host!
    
    let central = MCPeerID(displayName: UIDevice.current.name)
    let sessionDelegate = SessionDelegate()

    var serviceBrowser: MCNearbyServiceBrowser!
    var session: MCSession!
    var allPeers = [MCPeerID]()
    var peersToNotify: [MCPeerID] {
        return allPeers.filter({ $0 != central })
    }
    var imageReceived: [MCPeerID: UIImage] = [:]

    
    var onPeerJoin: ((_ peer: MCPeerID) -> ())?
    var onPeerLost: ((_ peer: MCPeerID, _ index: Int) -> ())?
    var onAllPeerImageReceived: ((_ images: [UIImage]) -> ())?
    
    func setup() {
        serviceBrowser = MCNearbyServiceBrowser(peer: central, serviceType: "bullettime")
        serviceBrowser.delegate = self
        session = MCSession(peer: central, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.optional)
        session.delegate = sessionDelegate
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .peerReady {
                self?.peerJoined(peer)
            }
            else if command == .peerImage {
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
        let data = JSONData(command: .startRecording)
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendStopRecording() {
        let data = JSONData(command: .stopRecording)
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendFinalResult(_ images: [UIImage]) {
        let data = JSONData(command: .finalResult, value: JSON(images.map {
            $0.toBase64String()
        }))
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendUseFrame(atTime time: Float64) {
        let data = JSONData(command: .useFrame, value: [
            "time": String(format:"%.8f", time)
        ])
        session.sendData(data, toPeers: peersToNotify)
    }
    
    func sendPeersUpdates() {
        let count = "\(allPeers.count)"
        for peer in peersToNotify {
            let index = "\(allPeers.index(of: peer)!)"
            let data = JSONData(command: .peersUpdates, value: JSON([
                "count": count,
                "index": index
            ]))
            session.sendData(data, toPeers: [peer])
        }
    }
    
     // MARK: event handler
    fileprivate func peerJoined(_ peer: MCPeerID) {
        guard allPeers.index(of: peer) == nil else {
            return
        }
        allPeers.append(peer)
        sendPeersUpdates()
        onPeerJoin?(peer)
    }

    fileprivate func peerLost(_ peer: MCPeerID) {
        guard let index = allPeers.index(of: peer) else {
            return
        }
        allPeers.remove(at: index)
        sendPeersUpdates()
        onPeerLost?(peer, index)
    }
    
    fileprivate func peerImageReceived(_ image: UIImage, fromPeer peer: MCPeerID) {
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
        onAllPeerImageReceived?(images)
    }
    

    // MARK: life cycle
    static func reset() {
        shared = Host()
        shared.setup()
    }
    
    static func current() -> Host {
        return shared
    }
    
    deinit {
        serviceBrowser.stopBrowsingForPeers()
    }
}

extension Host: MCNearbyServiceBrowserDelegate {
    
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let _ = allPeers.index(of: peerID) {
            return
        }
        serviceBrowser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peerLost(peerID)
    }
    
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        
    }
    
}
