//
//  MakeNewTargetView.swift
//  SBScavengerHunt
//
//  Created by David Sweetman on 6/27/14.
//  Copyright (c) 2014 smashingboxes. All rights reserved.
//

import UIKit

class MakeNewTargetViewController: UIViewController,
UITextFieldDelegate, UITextViewDelegate, ESTBeaconManagerDelegate {
    
    var targetBeacon: ESTBeacon?
    var beaconManager: ESTBeaconManager?
    var moc: NSManagedObjectContext?
    var hunt: Hunt?
    var target: HuntTarget?
    var descriptions = [/*TooFar*/"", /*Far*/"", /*Near*/"", /*Found*/""]
    var descriptionPlaceholders = ["Give a hint they are not even close","Hint that they are getting warmer","Hint that they are almost there!","Hint that they are right on top of it!"]
    var selectedSegmentIndex: Int?
    @IBOutlet var titleTextField : UITextField
    @IBOutlet var hintTextField : UITextView
    @IBOutlet var beaconFoundLabel : UILabel
    @IBOutlet var segmentedControl : UISegmentedControl
    var descriptionPlaceholderLabel : UITextView?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        target = HuntTarget(
            entity: NSEntityDescription.entityForName("HuntTarget", inManagedObjectContext: moc),
            insertIntoManagedObjectContext: moc
        )
        
        beaconManager = ESTBeaconManager()
        beaconManager!.delegate = self;
        var uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
        var beaconRegion = ESTBeaconRegion(proximityUUID: uuid, identifier: "estimote")
        beaconManager!.startRangingBeaconsInRegion(beaconRegion)
        
        if let h = hunt {
            var t = h.targets.mutableCopy() as NSMutableOrderedSet
            t.addObject(target)
            h.targets = t as NSOrderedSet
        }
        descriptionPlaceholderLabel = UITextView(frame: hintTextField.frame)
        descriptionPlaceholderLabel!.userInteractionEnabled = false
        hintTextField.superview.addSubview(descriptionPlaceholderLabel)
        descriptionPlaceholderLabel!.backgroundColor = UIColor.clearColor()
        descriptionPlaceholderLabel!.textColor = UIColor.lightGrayColor()
        descriptionPlaceholderLabel!.text = descriptionPlaceholders[0]
        selectedSegmentIndex = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveIfBeaconFound()
    }
    
    func beaconManager(manager: ESTBeaconManager,
        didRangeBeacons beacons: Array<AnyObject>,
        inRegion region: ESTBeaconRegion) {
            if beacons.count > 0 {
                var immediate: Array<ESTBeacon> = []
                for b: ESTBeacon in beacons as Array<ESTBeacon> {
                    if b.proximity == CLProximity.Immediate {
                        immediate.append(b)
                    }
                }
                if immediate.count > 1 {
                } else if immediate.count == 1 {
                    if (immediate[0] != targetBeacon) {
                        targetBeacon = immediate[0]
                        if (!isDuplicateTarget(targetBeacon!)) {
                            println("found beacon: \(targetBeacon!)")
                            updateBeaconDisplay()
                        }
                    }
                }
            }
    }
    
    func updateBeaconDisplay() {
        beaconFoundLabel.font = UIFont.systemFontOfSize(10.0)
        beaconFoundLabel.numberOfLines = 4
        beaconFoundLabel.text = "Found Beacon:\n\(targetBeacon!.proximityUUID.UUIDString)\n\(targetBeacon!.major.stringValue)\n\(targetBeacon!.minor.stringValue)"
    }
    
    func isDuplicateTarget(theTarget:ESTBeacon)->Bool
    {
        // Loop through the targets you have already set in the hunt
        // If found return true else no
        
        var allTargets:NSOrderedSet = hunt!.targets
        for i in (0..<hunt!.targets.count) {
            let htarget:HuntTarget = hunt!.targets.objectAtIndex(i) as HuntTarget
            if (htarget.proximity? == theTarget.proximityUUID.UUIDString && htarget.major? == theTarget.major.stringValue && htarget.minor? == theTarget.minor.stringValue) {
                return true
            }
        }
        return false
    }
    
    @IBAction func segmentedControlDidChange(sender : AnyObject) {
        if selectedSegmentIndex != segmentedControl.selectedSegmentIndex {
            if let i = selectedSegmentIndex {
                descriptions[i] = hintTextField.text
            }
            selectedSegmentIndex = segmentedControl.selectedSegmentIndex
            hintTextField.text = descriptions[segmentedControl.selectedSegmentIndex]
            updatePlaceholderLabel(hintTextField)
        }
    }
    
    @IBAction func doneButtonPressed(sender : AnyObject) {
        navigationController.popViewControllerAnimated(true)
    }
    
    func saveIfBeaconFound() {
        if let tb = targetBeacon {
            target!.title = titleTextField.text
            target!.descOutOfRange = descriptions[0]
            target!.descFar = descriptions[1]
            target!.descNear = descriptions[2]
            target!.descImmediate = descriptions[3]
            
            target!.proximity = tb.proximityUUID.UUIDString
            target!.major = tb.major.stringValue
            target!.minor = tb.minor.stringValue
            
        } else {
            moc!.deleteObject(target)
        }
        moc!.save(nil)
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText string: String!) -> Bool {
        if string == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange (textView: UITextView!) {
        updatePlaceholderLabel(textView)
    }
    
    func updatePlaceholderLabel(textView: UITextView!) {
        if textView.text == "" {
            descriptionPlaceholderLabel!.text = descriptionPlaceholders[segmentedControl.selectedSegmentIndex]
        } else {
            descriptionPlaceholderLabel!.text = ""
        }
    }
    

    
}
