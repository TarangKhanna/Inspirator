//
//  ViewController.swift
//  AutomatePortal
//
//  Created by Tarang Khanna on 2/28/15. Design inspiration form AppDesign Vault.
//  Copyright (c) 2015 Thacked. All rights reserved.
//

//MAKE SURE USER IS LOGGED IN

import Foundation
import UIKit
import MapKit
import Parse
import Social

class TimelineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, floatMenuDelegate {
    
    @IBOutlet var postData: MKTextField!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var toolbar : UIToolbar!
    var parseObject:PFObject?
    var currLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    //var transitionOperator = TransitionOperator()
    var messages = [String]()
    var createdAt = [Int]()
    var score = [Int]()
    var userArray: [String] = []
    var imageFiles = [PFFile]()
    var selectedName: String = "default"
    var selectedScore: String = "default"
    var selectedAbout: String = "default"
    var startTime: CFAbsoluteTime!
    var timeAtPress: NSDate!
    var elapsedTime: NSDate!
    var duration : Int = 0
    var profileImageFile = PFFile()
    var circleColors = [UIColor.MKColor.LightBlue, UIColor.MKColor.Grey, UIColor.MKColor.LightGreen]
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser()?.username == nil {
            //signin vc
            performSegueWithIdentifier("signIn", sender: self)
        }
        println("BHWJBE")
        println(PFUser.currentUser()?.username)
        
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
        self.automaticallyAdjustsScrollViewInsets = false
        //        let imgView = MKImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 32))
        //        imgView.image = UIImage(named: "EditFile-50.png")
        //        imgView.backgroundAniEnabled = false
        //        imgView.rippleLocation = .Center
        //        imgView.ripplePercent = 1.15
        //        imgView.userInteractionEnabled = true
        //
        //        let rightButton = UIBarButtonItem(customView: imgView)
        //        self.navigationItem.rightBarButtonItem = rightButton
        
        
        //        postData.layer.borderColor = UIColor.clearColor().CGColor
        //        postData.placeholder = "Placeholder"
        //        postData.tintColor = UIColor.grayColor()
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBG.png")!)
        //self.view.backgroundColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0) //teal
        //self.navigationController?.hidesBarsOnSwipe = true
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0) //teal
        tableView.backgroundColor = UIColor.clearColor()
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
        
        let floatFrame:CGRect = (CGRectMake(UIScreen.mainScreen().bounds.size.width - 44 - 20, UIScreen.mainScreen().bounds.size.height - 44 - 20, 44, 44))
        let actionButton : VCFloatingActionButton = VCFloatingActionButton(frame: floatFrame, normalImage: UIImage(named: "plus.png"), andPressedImage: UIImage(named: "cross.png"), withScrollview: tableView)
        //actionButton.normalImage = UIImage(named: "plus.png")!
        self.view.addSubview(actionButton)
        actionButton.imageArray = ["fb-icon.png","twitter-icon.png","google-icon.png","linkedin-icon.png"]
        actionButton.labelArray = ["Facebook","Twitter","Google Plus","LinkedIn"]
        actionButton.delegate = self
        actionButton.hideWhileScrolling = true
        retrieve()
        self.tableView.addPullToRefresh({ [weak self] in
            // refresh code
            self!.retrieve()
            //self?.retrieve()
            //self?.tableView.reloadData()
            self?.tableView.stopPullToRefresh()
            })
    }
    
    func retrieve() {
        
        
        if var query = PFQuery(className: "Person") as PFQuery? { //querying parse for user data
            var usr = PFUser.currentUser()!.username
            
            //query.whereKey("username", EqualTo: usr!)
            
            
            query.orderByDescending("createdAt")
            query.whereKey("text", notEqualTo: "")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                //self.createdAt.append("gwef")
                self.imageFiles.removeAll(keepCapacity: true)
                self.messages.removeAll(keepCapacity: false)
                self.userArray.removeAll(keepCapacity: false)
                self.score.removeAll(keepCapacity: false)
                self.createdAt.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject]  {
                    
                    for object in objects {
                        
                        self.messages.append(object["text"] as! String)
                        self.userArray.append(object["username"] as! String)
                        self.score.append(object["score"] as! Int)
                        let elapsedTime = CFAbsoluteTimeGetCurrent() - (object["startTime"] as! CFAbsoluteTime)
                        self.duration = Int(elapsedTime/60)
                        self.createdAt.append(self.duration)
                    }
                    self.tableView.reloadData()
                }
            })
        }
        
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
        //tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        
        var likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Like" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // parse like and notification
        })
        
        return [shareAction,likeAction]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //if (indexPath.row == 0) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineCell
        cell.backgroundColor = UIColor.clearColor()
        let index = indexPath.row % circleColors.count
        cell.rippleLayerColor = circleColors[index]
        //            if  indexPath.row % 2 == 0 {
        //                cell.backgroundColor = UIColor.redColor()
        //            } else {
        //                cell.backgroundColor = UIColor.purpleColor()
        //            }
        if !userArray[indexPath.row].isEmpty{
            //get profile pic
            var queryUser = PFUser.query() as PFQuery?
            queryUser!.findObjectsInBackgroundWithBlock {
                (users: [AnyObject]?, error: NSError?) -> Void in
                queryUser!.orderByDescending("createdAt")
                queryUser!.whereKey("username", equalTo: self.userArray[indexPath.row])
                if error == nil {
                    //println("Successfully retrieved \(users!.count) users.")
                    // Do something with the found users
                    if let users = users as? [PFObject] {
                        for user in users {
                            var user2:PFUser = user as! PFUser
                            self.profileImageFile = user2["ProfilePicture"] as! PFFile
                            self.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                                
                                if let downloadedImage = UIImage(data: data!) {
                                    
                                    cell.profileImageView.image = downloadedImage
                                    
                                }
                                
                            }
                            //self.imageFiles.append(user2["ProfilePictue"] as! PFFile)
                            
                        }
                        //self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
        //got profile pic
        //self.tableView.insertRowsAtIndexPaths(0, withRowAnimation: UITableViewRowAnimation.Bottom)
        cell.typeImageView.image = UIImage(named: "timeline-chat")
        //cell.profileImageView.image = UIImage(named: "profile-pic-1")
        cell.nameLabel.text = userArray[indexPath.row] // to flip
        
        cell.nameLabel.textColor = UIColor.greenColor()
        //cell.nameLabel.textColor = UIColor.whiteColor()
        cell.postLabel?.text = messages[indexPath.row]
        cell.postLabel?.textColor = UIColor.whiteColor()
        var seconds = createdAt[indexPath.row]*60
        var temp = seconds
        var timeAgo = (seconds/60) // + " m ago"
        var ending = " Min Ago"
        if timeAgo >= 60 {
            timeAgo = (temp / 3600)
            ending = " Hours Ago"
        }
        cell.dateLabel.text = String(timeAgo) + ending
        cell.dateLabel.textColor = UIColor.whiteColor()
        cell.scoreLabel.textColor = UIColor.greenColor()
        cell.scoreLabel.text = "Likes - " + String(score[indexPath.row])
        
        return cell
        
        //        } else{
        //            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto") as! TimelineCell
        //
        //            cell.typeImageView.image = UIImage(named: "timeline-photo")
        //            cell.profileImageView.image = UIImage(named: "profile-pic-2")
        //            cell.nameLabel.text = "Charlie Su"
        //            cell.photoImageView?.image = UIImage(named: "dish")
        //            cell.dateLabel.text = "3 mins ago from UIUC (200m away)"
        //            return cell
        //        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedName = userArray[indexPath.row]
        selectedScore = String(score[indexPath.row])
        //let destinationVC = profileVC()
        //destinationVC.name = selectedName
        performSegueWithIdentifier("profileView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "profileView") { //pass data to VC
            var svc = segue.destinationViewController as! profileVC;
            println(selectedName)
            svc.name = selectedName
            svc.score = selectedScore
            //get profile pic
            var queryUser = PFUser.query() as PFQuery?
            queryUser!.findObjectsInBackgroundWithBlock {
                (users: [AnyObject]?, error: NSError?) -> Void in
                queryUser!.orderByDescending("createdAt")
                queryUser!.whereKey("username", equalTo: self.selectedName)
                if error == nil {
                    //println("Successfully retrieved \(users!.count) users.")
                    // Do something with the found users
                    if let users = users as? [PFObject] {
                        for user in users {
                            var user2:PFUser = user as! PFUser
                            self.profileImageFile = user2["ProfilePicture"] as! PFFile
                            svc.aboutYouLabel.text = user2["AboutYou"] as? String
                            self.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                                
                                if let downloadedImage = UIImage(data: data!) {
                                    
                                    svc.avatarImage.image = downloadedImage
                                    
                                }
                                
                            }
                            //self.imageFiles.append(user2["ProfilePictue"] as! PFFile)
                            
                        }
                        //self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }

        }
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    //let toViewController = segue.destinationViewController as! UIViewController
    //self.modalPresentationStyle = UIModalPresentationStyle.Custom
    //toViewController.transitioningDelegate = self.transitionOperator
    //  }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func didSelectMenuOptionAtIndex(row : NSInteger) {
        println(row)
        if(row == 0) {
            //fb
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookSheet.setInitialText("#GetMotivated")
                self.presentViewController(facebookSheet, animated: true, completion: nil)
            } else {
                //var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account from the iOS app to share.", preferredStyle: UIAlertControllerStyle.Alert)
                SCLAlertView().showWarning("Accounts", subTitle: "Please login to a Facebook account from the iOS app to share.")
                //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                //self.presentViewController(alert, animated: true, completion: nil)
            }
        } else if(row == 1) {
            //twitter
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterSheet.setInitialText("#GetMotivated")
                self.presentViewController(twitterSheet, animated: true, completion: nil)
            } else {
                SCLAlertView().showWarning("Accounts", subTitle: "Please login to a Twitter account from the iOS app to share.")
                //self.presentViewController(alert, animated: true, completion: nil)
            }
        } else if(row == 2) {
            //google+
        } else if(row == 3) {
            //LinkedIn
        } else if(row == 4) {
            //new
        }
    }
    
    @IBAction func post(sender: AnyObject) {
        let alert = SCLAlertView() // input dialog
        let txt = alert.addTextField(title:"Enter Your Thoughts")
        alert.addButton("Post") {
            println("Text value: \(txt.text)")
            if txt.text != " " && txt.text != nil && txt.text != ""{
                var person = PFObject(className:"Person")
                self.parseObject = person
                person["score"] = 0
                person["username"] = PFUser.currentUser()?.username
                person["admin"] = true
                person["text"] = txt.text
                person["startTime"] = CFAbsoluteTimeGetCurrent()
                person.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.retrieve()
                    } else {
                        println("Couldn't post!")
                        SCLAlertView().showWarning("Error Posting", subTitle: "Check Your Internet Connection.")
                    }
                }
            } else {
                // empty post
                SCLAlertView().showWarning("Error Posting", subTitle: "You need to write something in your post.")
                //SCLAlertView().showWarning("Error Posting", subTitle: "You need to write something in your post.", closeButtonTitle: "Cancel")
                //self.post(self)
            }
            // parse
            //self.retrieve()
        }
        alert.showEdit("Post", subTitle:"Type Something Inspirational:", closeButtonTitle: "Cancel")
        
    }
    
    
}

