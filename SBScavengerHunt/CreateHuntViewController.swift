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
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName:nibName, bundle:nibBundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        broadcast()
        let label = UILabel(frame: CGRectInset(view.frame, 18.0, 0))
        label.numberOfLines = 5
        label.text = "Broadcasting a scavenger hunt:\n   " + hunt!.title + "\n" + "   \(hunt!.targets.count) beacon target" + (hunt!.targets.count == 1 ? "." : "s.")
        view.addSubview(label)
    }
    
    func broadcast() {
        theSession = MCSession(peer: localPeerID)
        theSession!.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: localPeerID, serviceType:"SB-Hunt")
        browser!.delegate = self
        browser!.startBrowsingForPeers()
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!)
    {
        browser.invitePeer(peerID, toSession: theSession, withContext: nil, timeout: 1000)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        println("lost peer")
    }
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!)
    {
        println("did not start")
    }
        
    //MARK: MCSessionDelegate
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        if state == MCSessionState.NotConnected {
            session.nearbyConnectionDataForPeer(peerID, withCompletionHandler: {(data: NSData!, error: NSError!) in
                session.connectPeer(peerID, withNearbyConnectionData: data)
                })
        } else if state == MCSessionState.Connected {
            session.sendData(hunt!.jsonData(), toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable, error: nil)
        }
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        println("CreateHuntVC didReceiveData")
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("CreateHuntVC didReceiveStream")
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("CreateHuntVC didStartReceivingResourceWithName")
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("CreateHuntVC didFinishReceivingResourceWithName")
    }
    
}