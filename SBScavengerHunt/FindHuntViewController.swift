//
//  FindHuntViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FindHuntViewController: UIViewController, MCNearbyServiceAdvertiserDelegate, UIActionSheetDelegate, MCSessionDelegate {
    
    var hunt: Hunt?
    var localPeerID = MCPeerID(displayName:UIDevice.currentDevice().name)
    var advertiser : MCNearbyServiceAdvertiser?
    var invitationHandler : ((Bool, MCSession!) -> Void)?
    var theSession : MCSession?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theSession = MCSession(peer: MCPeerID(displayName: UIDevice.currentDevice().name))
        theSession!.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer:localPeerID, discoveryInfo:nil, serviceType:"SB-Hunt")
        advertiser!.delegate = self;
        advertiser!.startAdvertisingPeer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!)
    {
        
        var actionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.title = "Received Invitation from \(peerID.displayName)"
        actionSheet.addButtonWithTitle("Reject")
        actionSheet.addButtonWithTitle("Accept")
        actionSheet.cancelButtonIndex = 0;
        actionSheet.showInView(self.view)
        
        self.invitationHandler = invitationHandler
    
    }
    
    func actionSheet(__actionSheet: UIActionSheet!,
        clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex {
        case 0:
            println("Rejected")
            if let ivh = invitationHandler
            {
                ivh(false, theSession)
            }
        case 1:
            println("Blocked")
            if let ivh = invitationHandler
            {
                ivh(false, theSession)
            }
        case 2:
            println("Accepted")
            if let ivh = invitationHandler
            {
                ivh(true, theSession)
            }
        default:
            println("nothing")
        }
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) { }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        var str = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("received data: \(str)")
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
