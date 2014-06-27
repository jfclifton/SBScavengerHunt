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

class CreateHuntViewController : UIViewController, MCNearbyServiceAdvertiserDelegate, UIActionSheetDelegate {
    
    var moc: NSManagedObjectContext?
    var localPeerID = MCPeerID(displayName:UIDevice.currentDevice().name)
    var advertiser : MCNearbyServiceAdvertiser = MCNearbyServiceAdvertiser()
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        // Custom init
        super.init(nibName:nibName, bundle:nibBundle)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        advertiser = MCNearbyServiceAdvertiser(peer:localPeerID, discoveryInfo:nil, serviceType:"SB-Hunt")
        advertiser.delegate = self;
        advertiser.startAdvertisingPeer()
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!)
    {
        var actionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.title = "Received Invitation from \(peerID.displayName)"
        actionSheet.addButtonWithTitle("Reject")
        actionSheet.addButtonWithTitle("Block")
        actionSheet.addButtonWithTitle("Accept")
        actionSheet.cancelButtonIndex = 0;
        actionSheet.showInView(self.view)
    
    }
    
    func actionSheet(__actionSheet: UIActionSheet!,
        clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex {
        case 0:
            println("Rejected")
    
        case 1:
            println("Blocked")
        
        case 2:
            println("Accepted")
            
        default:
            println("nothing")
        }
    }
    
}