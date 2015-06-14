//
//  TimeLineViewController.swift
//  AutomatePortal
//
//  Created by Tarang Khanna on 2/28/15. Design inspiration from AppDesign Vault.
//  Copyright (c) 2015 Thacked. All rights reserved.
//

//MAKE SURE USER IS LOGGED IN

import Foundation
import UIKit
import MapKit
import Parse
import Social
//import Spring

class TimelineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, floatMenuDelegate {
    
    @IBOutlet var postData: MKTextField!
    @IBOutlet var tableView : SBGestureTableView!
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var statusLabel: UILabel!
    
    var containsImage = [Bool]() // for loading images and making sure index is not out of bounds
    var votedArray = [String]()
    var activityIndicator = UIActivityIndicatorView()
    var indexPathStore = NSIndexPath()
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
    var backupImage = UIImage()
    var previousUser = String()
    var circleColors = [UIColor.MKColor.LightBlue, UIColor.MKColor.Grey, UIColor.MKColor.LightGreen, UIColor.MKColor.Amber, UIColor.MKColor.DeepOrange]
    var voteObject = [PFObject]()
    //var potentialVoteCounter : Int? = object["count"]
    
    // gesture tableview configs
    let checkIcon = FAKIonIcons.ios7CheckmarkIconWithSize(30)
    let closeIcon = FAKIonIcons.ios7ArrowUpIconWithSize(30) // downvote swipe left
    let composeIcon = FAKIonIcons.ios7ComposeIconWithSize(30)
    let clockIcon = FAKIonIcons.ios7ArrowDownIconWithSize(30) // upvote -swipe right
    let greenColor = UIColor(red: 85.0/255, green: 213.0/255, blue: 80.0/255, alpha: 1)
    let redColor = UIColor(red: 213.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
    let yellowColor = UIColor(red: 236.0/255, green: 223.0/255, blue: 60.0/255, alpha: 1)
    let brownColor = UIColor(red: 182.0/255, green: 127.0/255, blue: 78.0/255, alpha: 1)
    
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    
    var currentUser = String()
    
    override func viewWillAppear(animated: Bool) {
        var currentUser = PFUser.currentUser()?.username
        if currentUser == nil{
            //signin vc
            performSegueWithIdentifier("signIn", sender: self)
        } else {
            //println(PFUser.currentUser()?.username)
        }
    }
    
    @IBAction func upVote(sender: AnyObject) {
        //let buttonRow = sender.tag
        if let buttonRow = sender.tag {
            var votedBy = voteObject[buttonRow]["votedBy"] as! [String]
            if !contains(votedBy, currentUser) {
                var scoreParse = voteObject[buttonRow]["score"]! as? Int
                scoreParse = scoreParse! + 1
                voteObject[buttonRow].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                votedBy.append(currentUser)
                voteObject[buttonRow]["votedBy"] = votedBy
                voteObject[buttonRow].saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.retrieve()
                    } else {
                        println("Couldn't Vote!")
                        SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                    }
                }
                
            } else { // already voted -- add to retrieve also
                //               var indexPath = NSIndexPath(forRow: buttonRow, inSection: 0)
                println("Already Voted")
                //             self.tableView.reloadRowsAtIndexPaths([indexPathStore], withRowAnimation: UITableViewRowAnimation.Top)
            }
        }
    }
    
    @IBAction func downVote(sender: AnyObject) {
        if let buttonRow = sender.tag {
            var votedBy = voteObject[buttonRow]["votedBy"] as! [String]
            if !contains(votedBy, currentUser) {
                var scoreParse = voteObject[buttonRow]["score"]! as? Int
                scoreParse = scoreParse! - 1
                voteObject[buttonRow].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                votedBy.append(currentUser)
                voteObject[buttonRow]["votedBy"] = votedBy
                voteObject[buttonRow].saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.retrieve()
                    } else {
                        println("Couldn't Vote!")
                        SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                    }
                }
            } else { // already voted -- add to retrieve also
                println("Already Voted")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
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
        actionButton.labelArray = ["Facebook","Twitter","Google Plus","Log Out"]
        actionButton.delegate = self
        actionButton.hideWhileScrolling = true
        
        SwiftSpinner.show("Connecting to Matrix...")
        
        retrieve()
        
        self.tableView.addPullToRefresh({ [weak self] in
            // refresh code
            self!.retrieve()
            //self?.retrieve()
            //self?.tableView.reloadData()
            self?.tableView.stopPullToRefresh()
            })
        setupIcons()
        tableView.didMoveCellFromIndexPathToIndexPathBlock = {(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> Void in
            //self.objects.exchangeObjectAtIndex(toIndexPath.row, withObjectAtIndex: fromIndexPath.row)
        }
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            self.upVote(self)
        }
        
    }
    
    func setupIcons() {
        checkIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        closeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        composeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        clockIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
    }
    
    func retrieve() {
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        if var query = PFQuery(className: "Person") as PFQuery? { //querying parse for user data
            query.orderByDescending("createdAt")
            query.whereKey("text", notEqualTo: "")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                SwiftSpinner.hide()
                //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if error != nil {
                    //println("No Internet")
                    self.statusLabel.text = "No Internet. Try refreshing."
                }
                self.containsImage.removeAll(keepCapacity: false)
                self.imageFiles.removeAll(keepCapacity: false)
                self.messages.removeAll(keepCapacity: false)
                self.userArray.removeAll(keepCapacity: false)
                self.score.removeAll(keepCapacity: false)
                self.createdAt.removeAll(keepCapacity: false)
                self.voteObject.removeAll(keepCapacity: false)
                self.votedArray.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject]  {
                    for object in objects {
                        if let imageFile42 = object["imageFile"] as? PFFile{
                            self.imageFiles.append(imageFile42)
                            self.containsImage.append(true)
                            println("iuhewbd")
                        } else {
                            self.containsImage.append(false)
                            println("jkbdj")
                        }
                        self.voteObject.append(object)
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.stopUpdatingLocation()
        if(locations.count > 0){
            let location = locations[0] as! CLLocation
            currLocation = location.coordinate
        } else {
            println("error")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //tableView.reloadData()
    }
    
    //    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
    //
    //        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
    //
    //            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
    //
    //            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
    //            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    //
    //            shareMenu.addAction(twitterAction)
    //            shareMenu.addAction(cancelAction)
    //
    //
    //            self.presentViewController(shareMenu, animated: true, completion: nil)
    //        })
    //
    //        var likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Like" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
    //            // parse like and notification
    //        })
    //
    //        return [shareAction,likeAction]
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if containsImage[indexPath.row] {
            
            println("PIC")
            
            indexPathStore = indexPath
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto") as! SBGestureTableViewCell
            let size = CGSizeMake(30, 30)
            
            //get profile pic
            
            var queryUser = PFUser.query() as PFQuery?
            queryUser!.findObjectsInBackgroundWithBlock {
                (users: [AnyObject]?, error: NSError?) -> Void in
                //queryUser!.orderByDescending("createdAt")
                //queryUser!.whereKey("username", equalTo: self.userArray[indexPath.row])
                if error == nil {
                    //println("Successfully retrieved \(users!.count) users.")
                    // Do something with the found users
                    if let users = users as? [PFObject] {
                        for user in users {
                            var user2:PFUser = user as! PFUser
                            if user2.username == self.userArray[indexPath.row] {
                                self.profileImageFile = user2["ProfilePicture"] as! PFFile
                                self.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                                    
                                    if let downloadedImage = UIImage(data: data!) {
                                        
                                        cell.profileImageView.image = downloadedImage
                                        self.backupImage = downloadedImage
                                    }
                                    
                                }
                                //self.imageFiles.append(user2["ProfilePictue"] as! PFFile)
                                
                            }
                        }
                    }
                } else {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
            //got profile pic
            
            cell.firstLeftAction = SBGestureTableViewCellAction(icon: checkIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell.secondLeftAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: greenColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            cell.firstRightAction = SBGestureTableViewCellAction(icon: composeIcon.imageWithSize(size), color: yellowColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            
            cell.backgroundColor = UIColor.clearColor()
            cell.downVoteBtn.tag = indexPath.row
            
            cell.downVoteBtn.addTarget(self, action: "downVote:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.upVoteBtn.tag = indexPath.row
            
            cell.upVoteBtn.addTarget(self, action: "upVote:", forControlEvents: UIControlEvents.TouchUpInside)
            let index = indexPath.row % circleColors.count
            cell.rippleLayerColor = circleColors[index]
            let image42 = self.imageFiles[indexPath.row]
            image42.getDataInBackgroundWithBlock { (data, error) -> Void in
                if let downloadedImage2 = UIImage(data: data!) {
                    //cell.profileImageView.image = downloadedImage
                    //self.backupImage = downloadedImage
                    //self.tableView.insertRowsAtIndexPaths(0, withRowAnimation: UITableViewRowAnimation.Bottom)
                    cell.typeImageView.image = UIImage(named: "timeline-chat")
                    cell.photoImageView?.image = downloadedImage2
                    //cell.profileImageView.image = UIImage(named: "profile-pic-1")
                    cell.nameLabel.text = self.userArray[indexPath.row]
                    cell.nameLabel.textColor = UIColor.greenColor()
                    cell.postLabel?.text = self.messages[indexPath.row]
                    cell.postLabel?.textColor = UIColor.whiteColor()
                    var seconds = self.createdAt[indexPath.row]*60
                    var temp = seconds
                    var timeAgo = (seconds/60) // + " m ago"
                    var ending = " Min Ago"
                    if timeAgo >= 60 {
                        timeAgo = (temp / 3600)
                        ending = " Hours Ago"
                    }
//                    cell.dateLabel.text = String(timeAgo) + ending
//                    cell.dateLabel.textColor = UIColor.whiteColor()
                    cell.scoreLabel.textColor = UIColor.greenColor()
                    cell.scoreLabel.text = String(self.score[indexPath.row])
                    cell.typeImageView.image = UIImage(named: "timeline-photo")
                    cell.nameLabel.text = self.userArray[indexPath.row]
                    cell.nameLabel.textColor = UIColor.greenColor()
//                    cell.postLabel?.text = self.messages[indexPath.row]
//                    cell.postLabel?.textColor = UIColor.whiteColor()
                }
            }
            
            UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                cell.photoImageView!.alpha = 1.0;
                },completion: nil)
            return cell
        } else {
            
             println("TEXT")
            
            indexPathStore = indexPath
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! SBGestureTableViewCell
            let size = CGSizeMake(30, 30)
            
            //get profile pic
            
            var queryUser = PFUser.query() as PFQuery?
            queryUser!.findObjectsInBackgroundWithBlock {
                (users: [AnyObject]?, error: NSError?) -> Void in
                //queryUser!.orderByDescending("createdAt")
                //queryUser!.whereKey("username", equalTo: self.userArray[indexPath.row])
                if error == nil {
                    //println("Successfully retrieved \(users!.count) users.")
                    // Do something with the found users
                    if let users = users as? [PFObject] {
                        for user in users {
                            var user2:PFUser = user as! PFUser
                            if user2.username == self.userArray[indexPath.row] {
                                self.profileImageFile = user2["ProfilePicture"] as! PFFile
                                self.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                                    
                                    if let downloadedImage = UIImage(data: data!) {
                                        
                                        cell.profileImageView.image = downloadedImage
                                        self.backupImage = downloadedImage
                                    }
                                    
                                }
                                //self.imageFiles.append(user2["ProfilePictue"] as! PFFile)
                                
                            }
                        }
                    }
                } else {
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
            //got profile pic
            
            cell.firstLeftAction = SBGestureTableViewCellAction(icon: checkIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell.secondLeftAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: greenColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            cell.firstRightAction = SBGestureTableViewCellAction(icon: composeIcon.imageWithSize(size), color: yellowColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            
            cell.backgroundColor = UIColor.clearColor()
            cell.downVoteBtn.tag = indexPath.row
            
            cell.downVoteBtn.addTarget(self, action: "downVote:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.upVoteBtn.tag = indexPath.row
            
            cell.upVoteBtn.addTarget(self, action: "upVote:", forControlEvents: UIControlEvents.TouchUpInside)
            let index = indexPath.row % circleColors.count
            cell.rippleLayerColor = circleColors[index]
            //            if  indexPath.row % 2 == 0 {
            //                cell.backgroundColor = UIColor.redColor()
            //            } else {
            //                cell.backgroundColor = UIColor.purpleColor()
            //            }
            //get profile pic
            
            //self.tableView.insertRowsAtIndexPaths(0, withRowAnimation: UITableViewRowAnimation.Bottom)
            cell.typeImageView.image = UIImage(named: "timeline-chat")
            //cell.profileImageView.image = UIImage(named: "profile-pic-1")
            cell.nameLabel.text = self.userArray[indexPath.row]
            cell.nameLabel.textColor = UIColor.greenColor()
            cell.postLabel?.text = self.messages[indexPath.row]
            cell.postLabel?.textColor = UIColor.whiteColor()
            var seconds = self.createdAt[indexPath.row]*60
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
            cell.scoreLabel.text = String(self.score[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedName = userArray[indexPath.row]
        selectedScore = String(score[indexPath.row])
        //let destinationVC = profileVC()
        //destinationVC.name = selectedName
        //ce
        println("selected")
        println(indexPath.row)
        performSegueWithIdentifier("profileView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "profileView") { //pass data to VC
            var svc = segue.destinationViewController as! profileVC;
            println(selectedName)
            svc.name = selectedName
            svc.score = selectedScore
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
            //LinkedIn//to logout
            PFUser.logOut()
            performSegueWithIdentifier("signIn", sender: self)
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
                person["votedBy"] = []
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
    
    
    //func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //  var ns = self.messages[indexPath.row] as NSString
    // ns.sizeWithAttributes(ns)
    //}
    
}

