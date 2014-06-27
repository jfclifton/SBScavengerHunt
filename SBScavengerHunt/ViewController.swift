//
//  ViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    var moc: NSManagedObjectContext?
    
    var browser : MCNearbyServiceBrowser?
    var browserVC : MCBrowserViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var delegate = UIApplication.sharedApplication().delegate as AppDelegate
        moc = delegate.managedObjectContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onCreatePressed(sender: AnyObject) {
        var createVC = CreateHuntViewController(nibName:"CreateHuntViewController", bundle:nil)
        self.navigationController.pushViewController(createVC, animated: true)
        
//        var newHuntVC = MakeNewHuntViewController(nibName:"MakeNewHuntViewController", bundle:nil)
//        newHuntVC.moc = moc
//        self.navigationController.pushViewController(newHuntVC, animated: true)
    }

    @IBAction func onFind(sender: AnyObject) {
        let findVC = FindHuntViewController(nibName: "FindHuntViewController", bundle: nil)
        navigationController.pushViewController(findVC, animated: true)
    }
    
}

