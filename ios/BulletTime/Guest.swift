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

class Guest: NSObject {
    
    static var current: Guest!
    
    let peer = MCPeerID(displayName: UIDevice.currentDevice().name)
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    var session : MCSession!
    var central: MCPeerID!
    let sessionDelegate = SessionDelegate()
    
    var onConnected: (() -> ())?
    var onDisConnected: (() -> ())?
    var onPeersUpdates: ((index: Int, totalCount: Int) -> ())?
    var onStartRecording: (() -> ())?
    var onStopRecording: (() -> ())?
    var onUseFrame: ((time: Float64) -> ())?
    var onReceiveFinalResult: ((images: [UIImage]) -> ())?
    
    func setup() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "bullettime")
        serviceAdvertiser.delegate = self
        session = MCSession(peer: peer)
        session.delegate = sessionDelegate
        sessionDelegate.dataReceived = { [weak self] data, peer in
            let command = data.command
            if command == .PeersUpdates {
                let json = data.value!
                let totalCount = json["count"].intValue
                let index = json["index"].intValue
                self?.updatePeersInfo(index, totalCount: totalCount)
            }
            else if command == .StartRecording {
                self?.startRecording()
            }
            else if command == .StopRecording {
                self?.stopRecording()
            }
            else if command == .UseFrame {
                let time = data.value!["time"].stringValue
                self?.useFrame(atTime: Float64(time)!)
            }
            else if command == .FinalResult {
                let images = data.value!.arrayValue.map({
                    UIImage.imageFromBase64String($0.stringValue)
                })
                self?.receiveFinalResult(images)
            }
            
        }
        sessionDelegate.stateChanged = { [weak self] state in
            if state == .Connected {
                self?.sendReadySignal()
                self?.onConnected?()
            }
            else if state == .NotConnected {
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
            session.sendData(Data(command: .PeerReady), toPeers: [central])
        }
    }
    
    func sendImage(image: UIImage) {
        let data = Data(command: .PeerImage, value: JSON(image.toBase64String()))
        session.sendData(data, toPeers: [central])
    }

    
    // MARK: event handler
    private func updatePeersInfo(index: Int, totalCount: Int) {
        onPeersUpdates?(index: index, totalCount: totalCount)
    }
    
    private func startRecording() {
        onStartRecording?()
    }
    
    private func stopRecording() {
        onStopRecording?()
    }
    
    private func useFrame(atTime time: Float64) {
        onUseFrame?(time: time)
    }
    
    private func receiveFinalResult(images: [UIImage]) {
        onReceiveFinalResult?(images: images)
    }
    
    // MARK: life cycle
    static func reset() {
        current = Guest()
        current.setup()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
}

extension Guest: MCNearbyServiceAdvertiserDelegate {
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        central = peerID
        invitationHandler(true, session)
    }
    
    internal func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
}