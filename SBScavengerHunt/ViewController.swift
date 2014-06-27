//
//  ViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate {
    
    var theSession : MCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCreatePressed(sender: AnyObject) {
        var createVC = CreateHuntViewController(nibName:"CreateHuntViewController", bundle:nil)
        createVC.session = theSession
        self.navigationController.pushViewController(createVC, animated: true)
        
    }

    @IBAction func onFind(sender: AnyObject) {
        var browser = MCNearbyServiceBrowser(peer: MCPeerID(displayName: UIDevice.currentDevice().name), serviceType:"SB-Hunt")
        browser.delegate = self
        
        theSession = MCSession(peer: MCPeerID(displayName: UIDevice.currentDevice().name))
        
        var browserVC = MCBrowserViewController(browser: browser, session: theSession)
        browserVC.delegate = self
        
        self.presentViewController(browserVC, animated: true, completion: {
            browser.startBrowsingForPeers()
            })
        
        
    }
    
    
    
    func browserViewController(browserViewController: MCBrowserViewController!, shouldPresentNearbyPeer peerID: MCPeerID!, withDiscoveryInfo info: NSDictionary!) -> Bool
    {
        return true
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!)
    {
        
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!)
    {
        
    }
    
    
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: NSDictionary!)
    {
        println("peer: \(peerID.displayName)")
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!)
    {
        
    }
}

