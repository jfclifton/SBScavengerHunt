//
//  MakeNewHuntViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit

class MakeNewHuntViewController: UIViewController {
    
    var moc : NSManagedObjectContext?
    var hunt : Hunt?
    @IBOutlet var titleTextField : UITextField
    @IBOutlet var descriptionTextField : UITextField
    @IBOutlet var addNewTargetBtn : UIButton
    @IBOutlet var targetsTableView : UITableView
    @IBOutlet var doneButton : UIButton
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hunt = Hunt(
            entity: NSEntityDescription.entityForName("Hunt", inManagedObjectContext: moc),
            insertIntoManagedObjectContext: moc
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addNewTargetBtnPressed(sender : AnyObject) {
        let targetVC = MakeNewTargetViewController(nibName: "MakeNewTargetViewController", bundle: nil)
        targetVC.moc = moc
        targetVC.hunt = hunt
        
    }
    
    @IBAction func doneButtonPressed(sender : AnyObject) {
        
    }
}
