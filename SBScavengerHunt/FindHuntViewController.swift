//
//  FindHuntViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FindHuntViewController: UIViewController,
MCNearbyServiceAdvertiserDelegate, UIActionSheetDelegate, MCSessionDelegate, CLLocationManagerDelegate {
    
    var hunt: Hunt?
    var localPeerID = MCPeerID(displayName:UIDevice.currentDevice().name)
    var advertiser : MCNearbyServiceAdvertiser?
    var invitationHandler : ((Bool, MCSession!) -> Void)?
    var theSession : MCSession?
    let TITLE_ACCEPT = "Accept"
    let TITLE_REJECT = "Reject"
    
    var targetBeacon: ESTBeacon?
    var beaconManager: CLLocationManager?
    var beaconRegion: CLBeaconRegion?
    
    var dictionary : NSDictionary?
    var target : NSDictionary?

    @IBOutlet var beaconTitleLabel: UILabel
    @IBOutlet var huntDescLabel: UILabel
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
        
        var actionSheet = UIActionSheet(
            title: "Received Invitation from \(peerID.displayName)",
            delegate: self,
            cancelButtonTitle: TITLE_ACCEPT,
            destructiveButtonTitle: TITLE_REJECT
        )
        actionSheet.delegate = self
        self.invitationHandler = invitationHandler
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(__actionSheet: UIActionSheet!,
        clickedButtonAtIndex buttonIndex: Int)
    {
        println("ButtonIndex: \(buttonIndex)")
        switch buttonIndex {
        case __actionSheet.buttonTitleAtIndex(buttonIndex) == TITLE_ACCEPT:
            println("Accepted")
            if let ivh = invitationHandler
            {
                ivh(true, theSession)
            }
        case __actionSheet.buttonTitleAtIndex(buttonIndex) == TITLE_REJECT:
            println("Rejected")
            if let ivh = invitationHandler
            {
                ivh(false, theSession)
            }
        default:
            println("WARNING: title not found - \(__actionSheet.buttonTitleAtIndex(buttonIndex))")
        }
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("peer changed state: \(state)")
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
        var str = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("received data: \(str)")
        dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
        
        // For demo purposes: Just snag the *first* target, discard other targets.
        // Ideally, you would pay attention to all the targets in the hunt here.
        var t = dictionary!["targets"] as NSArray
        target = t[0] as? NSDictionary

        dispatch_async(dispatch_get_main_queue(), {
            
            self.beaconManager = CLLocationManager()
            self.beaconManager!.delegate = self;
            
            self.beaconTitleLabel.text = self.target!["title"] as String
            
            let uuid = NSUUID(UUIDString: self.target!["proximityUUID"] as String)
            println("uuid: \(uuid)")
            let major = self.target!["major"].intValue
            let minor = self.target!["minor"].intValue
            
            self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "target")
            self.beaconManager!.startRangingBeaconsInRegion(self.beaconRegion)
            
        })
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("session stream")
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("session resource")
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("session resource finished")        
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if beacons.count > 0 {
            let beacon : CLBeacon = beacons[0] as CLBeacon
            if beacon.proximity == CLProximity.Far {
                huntDescLabel.text = target!["far"] as String
            } else if (beacon.proximity == CLProximity.Near) {
                huntDescLabel.text = target!["near"] as String
            } else if (beacon.proximity == CLProximity.Immediate) {
                huntDescLabel.text = target!["immediate"] as String
            } else {
                huntDescLabel.text = target!["tooFar"] as String
            }
        } else {
            // No beacons were in range - use the too far text
            huntDescLabel.text = target!["tooFar"] as String
        }
    }
    
}
