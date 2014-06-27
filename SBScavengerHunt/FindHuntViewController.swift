//
//  FindHuntViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FindHuntViewController: UIViewController, MCNearbyServiceAdvertiserDelegate, UIActionSheetDelegate, MCSessionDelegate, ESTBeaconManagerDelegate {
    
    var hunt: Hunt?
    var localPeerID = MCPeerID(displayName:UIDevice.currentDevice().name)
    var advertiser : MCNearbyServiceAdvertiser?
    var invitationHandler : ((Bool, MCSession!) -> Void)?
    var theSession : MCSession?
    
    var targetBeacon: ESTBeacon?
    var beaconManager: ESTBeaconManager?
    
    var dictionary : NSDictionary?
    var targets : NSDictionary?

    @IBOutlet var huntDescLabel: UILabel
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        theSession = MCSession(peer: localPeerID)
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
        actionSheet.addButtonWithTitle("Accept")
        actionSheet.addButtonWithTitle("Reject")
        actionSheet.destructiveButtonIndex = 1;
        actionSheet.showInView(self.view)
        
//        invitationHandler(true, theSession)
        self.invitationHandler = invitationHandler
        
    
    }
    
    func actionSheet(__actionSheet: UIActionSheet!,
        clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex {
        case 0:
            println("Accepted")
            if let ivh = invitationHandler
            {
                ivh(true, theSession)
            }
        case 1:
            println("Rejected")
            if let ivh = invitationHandler
            {
                ivh(false, theSession)
            }
        default:
            println("nothing")
        }
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("peer changed state: \(state)")
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        var str = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("received data: \(str)")
        dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
        targets = dictionary!["targets"][0] as? NSDictionary
        
        beaconManager = ESTBeaconManager()
        beaconManager!.delegate = self;
        var uuid = NSUUID(UUIDString: targets!["proximityUUID"] as NSString)
        var major = targets!["major"] as NSNumber
        var minor = targets!["minor"] as NSNumber
        var beaconRegion = ESTBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major.intValue), minor: CLBeaconMajorValue(minor.intValue), identifier: "estimote")
        beaconManager!.startRangingBeaconsInRegion(beaconRegion)    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("session stream")
    }
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("session resource")
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("session resource finished")        
    }
    
    func beaconManager(manager: ESTBeaconManager,
        didRangeBeacons beacons: Array<AnyObject>,
        inRegion region: ESTBeaconRegion) {
            
            if beacons.count > 0 {
                let beacon : ESTBeacon = beacons[0] as ESTBeacon
                if beacon.proximity == CLProximity.Far {
                    
                }
            }
    }
}
