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
    case peerReady
    case peersUpdates
    case startRecording
    case stopRecording
    case useFrame
    case peerImage
    case finalResult
}

struct JSONData {
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

class SessionDelegate: NSObject, MCSessionDelegate {
    
    var dataReceived: ((_ data: JSONData, _ peer: MCPeerID) -> ())?
    
    var stateChanged: ((_ state: MCSessionState) -> ())?
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            let json = JSON(data: data)
            self.dataReceived?(JSONData(json: json), peerID)
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            self.stateChanged?(state)
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
}


extension MCSession {
    
    func sendData(_ data: JSONData, toPeers peers:[MCPeerID], withMode: MCSessionSendDataMode = .reliable) {
        var json = JSON([
            "c": data.command.rawValue
        ])
        if let value = data.value {
            json["v"] = value
        }
        do {
            try send(json.rawData(), toPeers: peers, with: .reliable)
        } catch {
            print(error)
        }
    }
}



