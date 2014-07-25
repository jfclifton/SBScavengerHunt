//
//  MyHuntsViewController.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 7/25/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit

class MyHuntsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView?
    var moc: NSManagedObjectContext?
    var hunts: Array<Hunt> = []
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Hunt", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("newHuntButtonPressed"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.frame = view.bounds
        
        fetchData()
    }
    
    func newHuntButtonPressed() {
        var newHuntVC = MakeNewHuntViewController(nibName:"MakeNewHuntViewController", bundle:nil)
        newHuntVC.moc = moc
        self.navigationController.pushViewController(newHuntVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchData() {
        let fetch = NSFetchRequest(entityName: "Hunt")
        fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        hunts = moc!.executeFetchRequest(fetch, error: nil) as Array<Hunt>
        tableView!.reloadData()
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return hunts.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("huntCell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "huntCell")
        }
        cell!.textLabel.text = hunts[indexPath.row].title
        return cell
    }
}
