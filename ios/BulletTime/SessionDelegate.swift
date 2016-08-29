//
//  SessionDelegate.swift
//  BulletTime
//
//  Created by ltebean on 8/13/16.
//  Copyright © 2016 ltebean. All rights reserved.
//

import MultipeerConnectivity
import SwiftyJSON

enum Command: Int {
    case PeerReady
    case PeersUpdates
    case StartRecording
    case StopRecording
    case UseFrame
    case PeerImage
    case FinalResult
}

struct Data {
    let command: Command
    var value: JSON?
    
    init(json: JSON) {
        self.command = Command.init(rawValue: json["c"].intValue)!
        self.value = json["v"]
    }
    
    init(command: Command) {
        self.command = command
    }
    
    init(command: Command, value: JSON) {
        self.command = command
        self.value = value
    }
}


extension MCSession {
    
    func sendData(data: Data, toPeers peers:[MCPeerID], withMode: MCSessionSendDataMode = .Reliable) {
        var json = JSON([
            "c": data.command.rawValue
        ])
        if let value = data.value {
            json["v"] = value
        }
        do {
            try sendData(json.rawData(), toPeers: peers, withMode: .Reliable)
        } catch {
            print(error)
        }
    }
}

class SessionDelegate: NSObject, MCSessionDelegate {
    
    var dataReceived: ((data: Data, peer: MCPeerID) -> ())?
    
    var stateChanged: ((state: MCSessionState) -> ())?
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        dispatch_async(dispatch_get_main_queue()) {
            self.stateChanged?(state: state)
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue()) {
            let json = JSON(data: data)
            self.dataReceived?(data: Data(json: json), peer: peerID)
        }
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
}


