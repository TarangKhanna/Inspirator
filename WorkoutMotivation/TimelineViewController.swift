//
//  ViewController.swift
//  AutomatePortal
//
//  Created by Tarang Khanna on 2/28/15. Design inspiration form AppDesign Vault.
//  Copyright (c) 2015 Thacked. All rights reserved.
//


import Foundation
import UIKit
import MapKit
import Parse

class TimelineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var toolbar : UIToolbar!
    var currLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    //var transitionOperator = TransitionOperator()
    
    
    var userArray: [String] = []
    //var counter = userArray.
    
    override func viewWillAppear(animated: Bool) {
        if var query = PFUser.query() { //querying parse for user names
            query.whereKey("username", notEqualTo: "")
            
            var users = query.findObjects()
            
            if let users = users as? [PFObject] {
                for user in users {
                    var user2:PFUser = user as! PFUser
                    println(user2.username!)
                    self.userArray.append(user2.username!)
                }
            }
        }
        
        //            query.findObjectsInBackgroundWithBlock {
        //                (users: [AnyObject]?, error: NSError?) -> Void in
        //
        //                self.tableView.reloadData()
        //
        //                if error == nil {
        //                    // The find succeeded.
        //                    println("Successfully retrieved \(users!.count) users.")
        //                    // Do something with the found users
        //                    if let users = users as? [PFObject] {
        //                        for user in users {
        //                            var user2:PFUser = user as! PFUser
        //                            println(user2.username!)
        //                            self.userArray.append(user2.username!)
        //                            //println("HERE\(self.userArray[0])")
        //                            //println(user.objectId!)
        //                            //self.userArray.append(user.username)
        //                        }
        //                        self.tableView.reloadData()
        //                    }
        //                } else {
        //                    // Log details of the failure
        //                    println("Error: \(error!) \(error!.userInfo!)")
        //                }
        //            }
        //        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //menuItem.image = UIImage(named: "menu")
        //toolbar.tintColor = UIColor.blackColor()
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager.delegate = self
        //        locationManager.requestWhenInUseAuthorization()
        //        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func GoLeft(sender: AnyObject) {
        // print("detected left 1")
        print("detected left ")
        performSegueWithIdentifier("presentNav", sender: self)
        
    }
    //    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    //        locationManager.stopUpdatingLocation()
    //        if(locations.count > 0){
    //            let location = locations[0] as! CLLocation
    //            currLocation = location.coordinate
    //        } else {
    //            println("error")
    //        }
    //    }
    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        println(error)
//    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineCell
            
            cell.typeImageView.image = UIImage(named: "timeline-chat")
            cell.profileImageView.image = UIImage(named: "profile-pic-1")
            cell.nameLabel.text = userArray[indexPath.row]
            cell.postLabel?.text = "The park bench located to the north of my location is really chill to take a nap or get some inspiration to code from a beautiful scenery"
            cell.dateLabel.text = "2 mins ago from UIUC (100m away)"
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto") as! TimelineCell
            
            cell.typeImageView.image = UIImage(named: "timeline-photo")
            cell.profileImageView.image = UIImage(named: "profile-pic-2")
            cell.nameLabel.text = "Charlie Su"
            cell.photoImageView?.image = UIImage(named: "dish")
            cell.dateLabel.text = "3 mins ago from UIUC (200m away)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("NearbySegue", sender: self)
    }
    
    @IBAction func presentNavigation(sender: AnyObject?){
        // performSegueWithIdentifier("presentNav", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as! UIViewController
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        //toViewController.transitioningDelegate = self.transitionOperator
    }
    
}

