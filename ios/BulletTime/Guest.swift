//
//  Guest.swift
//  BulletTime
//
//  Created by leo on 16/8/29.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import SwiftyJSON


class Guest: NSObject, MCNearbyServiceAdvertiserDelegate {
    
    static var current: Guest!
    
    let peer = MCPeerID(displayName: UIDevice.current.name)
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    var session : MCSession!
    var central: MCPeerID!
    let sessionDelegate = SessionDelegate()
    
    var onConnected: (() -> ())?
    var onDisConnected: (() -> ())?
    var onPeersUpdates: ((_ index: Int, _ totalCount: Int) -> ())?
    var onStartRecording: (() -> ())?
    var onStopRecording: (() -> ())?
    var onUseFrame: ((_ time: Float64) -> ())?
    var onReceiveFinalResult: ((_ images: [UIImage]) -> ())?
    
    func setup() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "bullettime")
        serviceAdvertiser.delegate = self
        session = MCSession(peer: peer)
        session.delegate = sessionDelegate
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .peersUpdates {
                let json = data.value!
                let totalCount = json["count"].intValue
                let index = json["index"].intValue
                self?.updatePeersInfo(index, totalCount: totalCount)
            }
            else if command == .startRecording {
                self?.startRecording()
            }
            else if command == .stopRecording {
                self?.stopRecording()
            }
            else if command == .useFrame {
                let time = data.value!["time"].stringValue
                self?.useFrame(atTime: Float64(time)!)
            }
            else if command == .finalResult {
                let images = data.value!.arrayValue.map({
                    UIImage.imageFromBase64String($0.stringValue)
                })
                self?.receiveFinalResult(images)
            }
            
        }
        sessionDelegate.stateChanged = { [weak self] state in
            if state == .connected {
                self?.sendReadySignal()
                self?.onConnected?()
            }
            else if state == .notConnected {
                self?.onDisConnected?()
            }
        }
        
    }
    
    
    // MARK: public
    func startAdvertising() {
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    // MARK: send signal
    func sendReadySignal() {
        if central != nil {
            session.sendData(JSONData(command: .peerReady), toPeers: [central])
        }
    }
    
    func sendImage(_ image: UIImage) {
        let data = JSONData(command: .peerImage, value: JSON(image.toBase64String()))
        session.sendData(data, toPeers: [central])
    }
    
    
    // MARK: event handler
    fileprivate func updatePeersInfo(_ index: Int, totalCount: Int) {
        onPeersUpdates?(index, totalCount)
    }
    
    fileprivate func startRecording() {
        onStartRecording?()
    }
    
    fileprivate func stopRecording() {
        onStopRecording?()
    }
    
    fileprivate func useFrame(atTime time: Float64) {
        onUseFrame?(time)
    }
    
    fileprivate func receiveFinalResult(_ images: [UIImage]) {
        onReceiveFinalResult?(images)
    }
    
    // MARK: life cycle
    static func reset() {
        current = Guest()
        current.setup()
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
    
    //    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    //        central = peerID
    //        invitationHandler(true, session)
    //    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
    }
    
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
}
