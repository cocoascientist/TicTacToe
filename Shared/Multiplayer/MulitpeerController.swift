//
//  MulitpeerController.swift
//  TicTacToad
//
//  Created by Andrew Shepard on 7/12/16.
//  Copyright © 2016 Andrew Shepard. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MulitpeerController: NSObject {
    private let timeStarted = NSDate()
    
    private let serviceType = "ajs-ttt-1"
    
    lazy var peer: MCPeerID = {
        let displayName = UUID().uuidString
        let peer = MCPeerID(displayName: displayName)
        return peer
    }()
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.peer)
        return session
    }()
    
    lazy var browser: MCNearbyServiceBrowser = {
        let browser = MCNearbyServiceBrowser(peer: self.peer, serviceType: self.serviceType)
        browser.delegate = self
        return browser
    }()
    
    lazy var advertiser: MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: self.peer, discoveryInfo: nil, serviceType: self.serviceType)
        
        advertiser.delegate = self
        return advertiser
    }()
}

extension MulitpeerController: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        var runningTime = -timeStarted.timeIntervalSinceNow
        let data = NSData(bytes: &runningTime, length: sizeof(TimeInterval.self))
        let context = data as Data
        
        browser.invitePeer(peerID, to: session, withContext: context, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost peer: \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print("error browsing for peers: \(error)")
    }
}

extension MulitpeerController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: (Bool, MCSession?) -> Void) {
        
        guard let context = context else { return }
        let data = context as NSData
        
        let runningTime = -timeStarted.timeIntervalSinceNow
        var peerRunningTime = TimeInterval()
        data.getBytes(&peerRunningTime, length: sizeof(TimeInterval.self))
        
        let isPeerOlder = (peerRunningTime > runningTime)
        
        if isPeerOlder {
            print("older")
        } else {
            print("younger")
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("error starting advertiser: \(error)")
    }
}
