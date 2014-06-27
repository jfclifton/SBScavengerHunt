//
//  CreateHuntViewController.swift
//  SBScavengerHunt
//
//  Created by JFClifton on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class CreateHuntViewController : UIViewController, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    var hunt: Hunt?
    var moc: NSManagedObjectContext?
    var localPeerID = MCPeerID(displayName:UIDevice.currentDevice().name)
    var theSession : MCSession?
    
    var browser : MCNearbyServiceBrowser?
    var browserVC : MCBrowserViewController?
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        // Custom init
        super.init(nibName:nibName, bundle:nibBundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        broadcast()
    }
    
    func broadcast() {
        browser = MCNearbyServiceBrowser(peer: MCPeerID(displayName: UIDevice.currentDevice().name), serviceType:"SB-Hunt")
        browser!.delegate = self
        
        theSession = MCSession(peer: MCPeerID(displayName: UIDevice.currentDevice().name))
        theSession!.delegate = self
        browser!.startBrowsingForPeers()
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: NSDictionary!) {
        browser.invitePeer(peerID, toSession: theSession, withContext: nil, timeout: 1000)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) { }
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) { }
    
    //MARK: MCSessionDelegate
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        if state == MCSessionState.NotConnected {
            session.connectPeer(peerID, withNearbyConnectionData: nil)
        } else if state == MCSessionState.Connected {
            session.sendData(hunt!.jsonData(), toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable, error: nil)
        }
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
}