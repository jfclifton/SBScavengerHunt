//
//  MakeNewHuntViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit

class MakeNewHuntViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource {
    
    var moc : NSManagedObjectContext?
    var hunt : Hunt?
    var targets : Array<HuntTarget>?
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateTargets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addNewTargetBtnPressed(sender : AnyObject) {
        let targetVC = MakeNewTargetViewController(nibName: "MakeNewTargetViewController", bundle: nil)
        targetVC.moc = moc
        targetVC.hunt = hunt
        self.navigationController.pushViewController(targetVC, animated: true)
    }
    
    @IBAction func doneButtonPressed(sender : AnyObject) {
        // Move to brodcast to local players
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return hunt!.targets.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ReuseID")
        cell.text = "\(targets![indexPath.row].title)"
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) { }
    
    func updateTargets() {
        targets = hunt!.targets.array as? Array<HuntTarget>
    }
}
