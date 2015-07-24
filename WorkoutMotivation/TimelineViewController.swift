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
import MessageUI
//import Spring

// fix lag

class TimelineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, floatMenuDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var postData: MKTextField!
    @IBOutlet var tableView : SBGestureTableView!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var newIndexPathRow: Int? = nil
    
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var statusLabel: UILabel!
    var selectedParseObjectId = String()
    var selectedParseObject:PFObject?
    var ParseObjectId : [String] = [""]
    //var selectedObject = PFObject()
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
    var selectedToReportMessage: String = "default"
    var selectedToReportObject:PFObject?
    var selectedAbout: String = "default"
    var startTime: CFAbsoluteTime!
    var timeAtPress: NSDate!
    var elapsedTime: NSDate!
    var duration : Int = 0
    var profileImageFile = PFFile()
    var profileImageFiles = [PFFile]()
    var previousUser = String()
    var circleColors = [UIColor.MKColor.LightBlue, UIColor.MKColor.Grey, UIColor.MKColor.LightGreen, UIColor.MKColor.Amber, UIColor.MKColor.DeepOrange]
    var voteObject = [PFObject]()
    //var potentialVoteCounter : Int? = object["count"]
    var selectedFirstPost = String()
    // gesture tableview configs
    let checkIcon = FAKIonIcons.ios7ArrowUpIconWithSize(30)
    let closeIcon = FAKIonIcons.ios7ArrowUpIconWithSize(30) // downvote swipe left
    let composeIcon = FAKIonIcons.ios7ArrowDownIconWithSize(30)
    let clockIcon = FAKIonIcons.ios7ArrowDownIconWithSize(30) // upvote -swipe right
    let greenColor = UIColor(red: 85.0/255, green: 213.0/255, blue: 80.0/255, alpha: 1)
    let redColor = UIColor(red: 213.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
    let yellowColor = UIColor(red: 236.0/255, green: 223.0/255, blue: 60.0/255, alpha: 1)
    let brownColor = UIColor(red: 182.0/255, green: 127.0/255, blue: 78.0/255, alpha: 1)
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    var groupToQuery : String? = "general"
    var currentUser : String? = nil
    var currentUserId : String? = nil
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let currentUser = PFUser.currentUser()!.username {
            currentUserId = PFUser.currentUser()?.objectId
        } else {
            performSegueWithIdentifier("signIn", sender: self)
        }
    }
    
    
    @IBAction func upVote(sender: AnyObject) {
        //let buttonRow = sender.tag
        if let buttonRow = sender.tag { // or from removeBlock
            var votedBy = voteObject[buttonRow]["votedBy"] as! [String]
            if !contains(votedBy, currentUserId!) {
                var scoreParse = voteObject[buttonRow]["score"]! as? Int
                scoreParse = scoreParse! + 1
                voteObject[buttonRow].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                println(currentUserId)
                votedBy.append(currentUserId!)
                voteObject[buttonRow]["upVote"] = true
                voteObject[buttonRow]["votedBy"] = votedBy
                voteObject[buttonRow].saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // update cell locally atleast and maybe not call self.retrieve
                        //
                        //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                        self.retrieve()
                    } else {
                        println("Couldn't Vote!")
                        SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                    }
                }
                
            } else { // already voted -- add to retrieve also
                //               var indexPath = NSIndexPath(forRow: buttonRow, inSection: 0)
                
                var upVoted : Bool = (voteObject[buttonRow]["upVote"]! as? Bool)!
                if !upVoted { // if prev was downvote
                    // then upvote by +2
                    var scoreParse = voteObject[buttonRow]["score"]! as? Int
                    scoreParse = scoreParse! + 2
                    voteObject[buttonRow].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                    //votedBy.append(currentUserId!)
                    voteObject[buttonRow]["upVote"] = true
                    //voteObject[buttonRow]["votedBy"] = votedBy
                    voteObject[buttonRow].saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            self.retrieve()
                        } else {
                            println("Couldn't Vote!")
                            SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                        }
                    }
                }
                
                println("Already Voted")
                //             self.tableView.reloadRowsAtIndexPaths([indexPathStore], withRowAnimation: UITableViewRowAnimation.Top)
            }
        } else {
            var votedBy = voteObject[newIndexPathRow!]["votedBy"] as! [String]
            if !contains(votedBy, currentUserId!) {
                var scoreParse = voteObject[newIndexPathRow!]["score"]! as? Int
                scoreParse = scoreParse! + 1
                voteObject[newIndexPathRow!].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                println(currentUserId)
                votedBy.append(currentUserId!)
                voteObject[newIndexPathRow!]["upVote"] = true
                voteObject[newIndexPathRow!]["votedBy"] = votedBy
                voteObject[newIndexPathRow!].saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // update cell locally atleast and maybe not call self.retrieve
                        //
                        //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                        self.retrieve()
                    } else {
                        println("Couldn't Vote!")
                        SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                    }
                }
                
            } else { // already voted -- add to retrieve also
                //               var indexPath = NSIndexPath(forRow: buttonRow, inSection: 0)
                
                var upVoted : Bool = (voteObject[newIndexPathRow!]["upVote"]! as? Bool)!
                if !upVoted { // if prev was downvote
                    // then upvote by +2
                    var scoreParse = voteObject[newIndexPathRow!]["score"]! as? Int
                    scoreParse = scoreParse! + 2
                    voteObject[newIndexPathRow!].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                    //votedBy.append(currentUserId!)
                    voteObject[newIndexPathRow!]["upVote"] = true
                    //voteObject[buttonRow]["votedBy"] = votedBy
                    voteObject[newIndexPathRow!].saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            self.retrieve()
                        } else {
                            println("Couldn't Vote!")
                            SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                        }
                    }
                }
                println("Already Voted")
                //             self.tableView.reloadRowsAtIndexPaths([indexPathStore], withRowAnimation: UITableViewRowAnimation.Top)
            }
            
        }
    }
    
    @IBAction func downVote(sender: AnyObject) {
        
        if let buttonRow = sender.tag {
            
            
            var votedBy = voteObject[buttonRow]["votedBy"] as! [String]
            if !contains(votedBy, currentUserId!) {
                var scoreParse = voteObject[buttonRow]["score"]! as? Int
                scoreParse = scoreParse! - 1
                voteObject[buttonRow].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                votedBy.append(currentUserId!)
                voteObject[buttonRow]["upVote"] = false
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
                var upVoted : Bool = (voteObject[buttonRow]["upVote"]! as? Bool)!
                if upVoted {
                    // then downvote by -2
                    var scoreParse = voteObject[buttonRow]["score"]! as? Int
                    scoreParse = scoreParse! - 2
                    voteObject[buttonRow].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                    //votedBy.append(currentUserId!)
                    voteObject[buttonRow]["upVote"] = false
                    //voteObject[buttonRow]["votedBy"] = votedBy
                    voteObject[buttonRow].saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            self.retrieve()
                        } else {
                            println("Couldn't Vote!")
                            SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                        }
                    }
                }
                println("Already Voted")
            }
        } else {
            var votedBy = voteObject[newIndexPathRow!]["votedBy"] as! [String]
            if !contains(votedBy, currentUserId!) {
                var scoreParse = voteObject[newIndexPathRow!]["score"]! as? Int
                scoreParse = scoreParse! - 1
                voteObject[newIndexPathRow!].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                votedBy.append(currentUserId!)
                voteObject[newIndexPathRow!]["upVote"] = false
                voteObject[newIndexPathRow!]["votedBy"] = votedBy
                voteObject[newIndexPathRow!].saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.retrieve()
                    } else {
                        println("Couldn't Vote!")
                        SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                    }
                }
            } else { // already voted -- add to retrieve also
                var upVoted : Bool = (voteObject[newIndexPathRow!]["upVote"]! as? Bool)!
                if upVoted {
                    // then downvote by -2
                    var scoreParse = voteObject[newIndexPathRow!]["score"]! as? Int
                    scoreParse = scoreParse! - 2
                    voteObject[newIndexPathRow!].setObject(NSNumber(integer: scoreParse!), forKey: "score")
                    //votedBy.append(currentUserId!)
                    voteObject[newIndexPathRow!]["upVote"] = false
                    //voteObject[buttonRow]["votedBy"] = votedBy
                    voteObject[newIndexPathRow!].saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            self.retrieve()
                        } else {
                            println("Couldn't Vote!")
                            SCLAlertView().showWarning("Error Voting", subTitle: "Check Your Internet Connection.")
                        }
                    }
                }
                println("Already Voted")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //        postData.layer.borderColor = UIColor.clearColor().CGColor
        //        postData.placeholder = "Placeholder"
        //        postData.tintColor = UIColor.grayColor()
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBG.png")!)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "loginBG.png"), forBarMetrics: UIBarMetrics.Compact)
        self.navigationController?.navigationBar.tintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        //self.view.backgroundColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0) //teal
        //self.navigationController?.hidesBarsOnSwipe = true
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0) //teal
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        var currentUser = PFUser.currentUser()?.username
        // set this image at time of signup / signin
        var userPhoto = UIImage()
        //        var queryUser = PFUser.query() as PFQuery?
        //        queryUser!.findObjectsInBackgroundWithBlock {
        //            (users: [AnyObject]?, error: NSError?) -> Void in
        //            if error == nil {
        //                if let users = users as? [PFObject] {
        //                    for user in users {
        //                        var user2:PFUser = user as! PFUser
        //                        if user2.username == self.currentUser
        //                        {
        //                            var userPhotoFile = user2["ProfilePicture"] as! PFFile
        //                            userPhotoFile.getDataInBackgroundWithBlock { (data, error) -> Void in
        //
        //                                if let downloadedImage = UIImage(data: data!) {
        //                                    userPhoto  = downloadedImage
        //                                    actionButton.imageArray = ["fb-icon.png","twitter-icon.png","google-icon.png","downloadedImage"]
        //                                }
        //
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
        
        SwiftSpinner.show("Connecting to Group...")
        
        retrieve()
        
        self.tableView.addPullToRefresh({ [weak self] in
            // refresh code
            SwiftSpinner.show("Refreshing")
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
            println(Int(cell.center.x))
            if Int(cell.center.x) > 0 { // upvote
                println(indexPath?.row)
                self.newIndexPathRow = indexPath?.row
                self.upVote(self)
            } else if Int(cell.center.x) < 0 {
                println(indexPath?.row)
                println("fjb    ejkbf")
                self.newIndexPathRow = indexPath?.row
                self.downVote(self)
            }
            UIView.animateWithDuration(0.2 * cell.percentageOffsetFromCenter(), animations: { () -> Void in
                //cell.center = CGPointMake(cell.frame.size.width/2 + (cell.frame.origin.x > 0 ? -bounce : bounce), cell.center.y)
                cell.leftSideView.iconImageView.alpha = 0
                cell.rightSideView.iconImageView.alpha = 0
                }, completion: {(done) -> Void in
                    UIView.animateWithDuration(0.2/2, animations: { () -> Void in
                        cell.center = CGPointMake(cell.frame.size.width/2, cell.center.y)
                        }, completion: {(done) -> Void in
                            cell.leftSideView.removeFromSuperview()
                            cell.rightSideView.removeFromSuperview()
                            //completion?()
                    })
            })
            println(cell.leftSideView)
            
            
        }
        
    }
    
    func setupIcons() {
        checkIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        closeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        composeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        clockIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
    }
    
    func retrieve() {
        var currentProfileUser = ""
        if var query = PFQuery(className: "Person") as PFQuery? { //querying parse for user data
            query.orderByDescending("createdAt")
            query.limit = 25
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error != nil {
                    self.statusLabel.text = "No Internet. Try refreshing."
                }
                self.containsImage.removeAll(keepCapacity: false)
                self.imageFiles.removeAll(keepCapacity: false)
                self.messages.removeAll(keepCapacity: false)
                self.profileImageFiles.removeAll(keepCapacity: false)
                self.userArray.removeAll(keepCapacity: false)
                self.score.removeAll(keepCapacity: false)
                self.createdAt.removeAll(keepCapacity: false)
                self.voteObject.removeAll(keepCapacity: false)
                self.votedArray.removeAll(keepCapacity: false)
                self.ParseObjectId.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject]  {
                    for object in objects {
                        if self.groupToQuery! == object["group"] as? String || self.groupToQuery == "general" { // here we set the group
                            if let imageFile42 = object["imageFile"] as? PFFile {
                                self.imageFiles.append(imageFile42)
                                self.containsImage.append(true)
                            } else {
                                self.imageFiles.append(PFFile())
                                self.containsImage.append(false)
                            }
                            currentProfileUser = object["username"] as! String
                            // append profile pics here and optimise
                            self.voteObject.append(object)
                            self.ParseObjectId.append((object.objectId! as String?)!)
                            self.messages.append(object["text"] as! String)
                            
                            self.userArray.append(currentProfileUser)
                            self.score.append(object["score"] as! Int)
                            let elapsedTime = CFAbsoluteTimeGetCurrent() - (object["startTime"] as! CFAbsoluteTime)
                            self.duration = Int(elapsedTime/60)
                            self.createdAt.append(self.duration)
                            
                        }
                    }
                }
                
                //dispatch_async(dispatch_get_main_queue()) {
                self.delay(0.3) {
                    var queryUser2 = PFUser.query() as PFQuery?
                    queryUser2!.findObjectsInBackgroundWithBlock {
                        (users: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            for user42 in self.userArray {
                                // Do something with the found users
                                if let users = users as? [PFObject] {
                                    for user in users {
                                        var user2:PFUser = user as! PFUser
                                        //println(user42)
                                        if user2.username == user42 {
                                            self.profileImageFiles.append(user2["ProfilePicture"] as! PFFile)
                                        }
                                        
                                    }
                                }
                            }
                        } else {
                            println("Error: \(error!) \(error!.userInfo!)")
                        }
                    }
                    //}
                }
                self.delay(6) {
                    println(self.profileImageFiles.count)
                    println("3io4h3jnk4jkn")
                    println(self.userArray.count)
                    // dispatch_async(dispatch_get_main_queue()) {
                    if self.profileImageFiles.count == self.userArray.count{
                        SwiftSpinner.hide()
                        self.tableView.reloadData()
                    } else {
                        self.retrieve()
                    }
                   
                }
                
            })
            //if profileImageFiles.count == userArray.count {
            
                
                // }
            //}
        }
        //dispatch_async(dispatch_get_main_queue()) {
        //self.loadProfileImages()
        //}
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //
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
            var cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto") as? SBGestureTableViewCell
            if cell == nil {
                cell = SBGestureTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TimelineCellPhoto")
            }
            let size = CGSizeMake(30, 30)
            
            let profileImage42 = self.profileImageFiles[indexPath.row]
            profileImage42.getDataInBackgroundWithBlock { (data, error) -> Void in
                if !(error != nil) {
                    if let downloadedImage = UIImage(data: data!) {
                        cell!.profileImageView?.image = downloadedImage
                    }
                }
            }
            
            // got profile pic
            // Profile Tap
            cell!.profileImageView.tag = indexPath.row
            var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageTapped:"))
            cell!.profileImageView.userInteractionEnabled = true
            cell!.profileImageView.addGestureRecognizer(tapGestureRecognizer)
            cell!.firstLeftAction = SBGestureTableViewCellAction(icon: checkIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            //cell.secondLeftAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: greenColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            cell!.firstRightAction = SBGestureTableViewCellAction(icon: composeIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            //cell.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            
            cell!.backgroundColor = UIColor.clearColor()
            //            cell.downVoteBtn.tag = indexPath.row
            //
            //            cell.downVoteBtn.addTarget(self, action: "downVote:", forControlEvents: UIControlEvents.TouchUpInside)
            //            cell.upVoteBtn.tag = indexPath.row
            //
            //            cell.upVoteBtn.addTarget(self, action: "upVote:", forControlEvents: UIControlEvents.TouchUpInside)
            var name = self.userArray[indexPath.row]
            name.replaceRange(name.startIndex...name.startIndex, with: String(name[name.startIndex]).capitalizedString)
            cell!.nameLabel.text = name
            cell!.nameLabel.textColor = UIColor.whiteColor()
            cell!.postLabel?.text = "​\u{200B}\(self.messages[indexPath.row])"
            cell!.postLabel?.textColor = UIColor.whiteColor()
            cell!.typeImageView.image = UIImage(named: "timeline-photo")
            let index = indexPath.row % circleColors.count
            cell!.rippleLayerColor = circleColors[index]
            var seconds = self.createdAt[indexPath.row]*60
            var temp = seconds
            var timeAgo = (seconds/60) // + " m ago"
            var ending = " min"
            var setAlready = false
            if timeAgo >= 60 { // min now
                timeAgo = (temp / 3600)
                ending = " hrs"
                if timeAgo >= 24 {
                    timeAgo = timeAgo / 24
                    ending = " days"
                    if timeAgo == 1 {
                        setAlready = true
                        cell!.dateLabel.text = "yesterday"
                    }
                }
            }
            if !setAlready {
                cell!.dateLabel.text = String(timeAgo) + ending
            }
            cell!.dateLabel.text = String(timeAgo) + ending
            cell!.dateLabel.textColor = UIColor.MKColor.Grey
            cell!.scoreLabel.textColor = UIColor.whiteColor()
            cell!.scoreLabel.text = "[" + String(self.score[indexPath.row]) + "]"
            
            let image42 = self.imageFiles[indexPath.row]
            image42.getDataInBackgroundWithBlock { (data, error) -> Void in
                if !(error != nil) {
                    if let downloadedImage2 = UIImage(data: data!) {
                        //self.tableView.insertRowsAtIndexPaths(0, withRowAnimation: UITableViewRowAnimation.Bottom)
                        cell!.photoImageView?.image = downloadedImage2
                    }
                }
            }
            return cell!
        } else {
            
            println("TEXT")
            
            indexPathStore = indexPath
            var cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as? SBGestureTableViewCell
            if cell == nil {
                cell = SBGestureTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TimelineCell")
            }
            let size = CGSizeMake(30, 30)
            println(profileImageFiles.count)
            let profileImage42 = self.profileImageFiles[indexPath.row]
            profileImage42.getDataInBackgroundWithBlock { (data, error) -> Void in
                if (error == nil) {
                    if let downloadedImage = UIImage(data: data!) {
                        cell!.profileImageView?.image = downloadedImage
                    }
                }
            }
            
            var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPressOptions:"))
            cell?.userInteractionEnabled = true
            cell?.addGestureRecognizer(longPressGestureRecognizer)
            cell!.profileImageView.tag = indexPath.row
            var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("profileImageTapped:"))
            cell!.profileImageView.userInteractionEnabled = true
            cell!.profileImageView.addGestureRecognizer(tapGestureRecognizer)
            cell!.firstLeftAction = SBGestureTableViewCellAction(icon: checkIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell!.secondLeftAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: greenColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            cell!.firstRightAction = SBGestureTableViewCellAction(icon: composeIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
            cell!.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
            
            cell!.backgroundColor = UIColor.clearColor()
            cell!.downVoteButton.tag = indexPath.row
            
            cell!.downVoteButton.addTarget(self, action: "downVote:", forControlEvents: UIControlEvents.TouchUpInside)
            cell!.upvoteButton.tag = indexPath.row
            
            cell!.upvoteButton.addTarget(self, action: "upVote:", forControlEvents: UIControlEvents.TouchUpInside)
            let index = indexPath.row % circleColors.count
            cell!.rippleLayerColor = circleColors[index]
            
            //self.tableView.insertRowsAtIndexPaths(0, withRowAnimation: UITableViewRowAnimation.Bottom)
            cell!.typeImageView.image = UIImage(named: "timeline-chat")
            //cell.profileImageView.image = UIImage(named: "profile-pic-1")
            var name = self.userArray[indexPath.row]
            name.replaceRange(name.startIndex...name.startIndex, with: String(name[name.startIndex]).capitalizedString)
            cell!.nameLabel.text = name
            cell!.nameLabel.textColor = UIColor.whiteColor()
            cell!.postLabel?.text = self.messages[indexPath.row]
            cell!.postLabel?.textColor = UIColor.whiteColor()
            var seconds = Double(self.createdAt[indexPath.row]*60)
            var temp = seconds
            var timeAgo = (seconds/60) // + " m ago"
            var ending = " min"
            var setAlready = false
            if timeAgo >= 60 { // min now
                timeAgo = (temp / 3600)
                ending = " hrs"
                if timeAgo >= 24.0 {
                    timeAgo = timeAgo / 24
                    ending = " days"
                    if timeAgo > 1.3 {
                        setAlready = true
                        cell!.dateLabel.text = "yesterday"
                    } else {
                        
                    }
                }
            }
            if !setAlready {
                cell!.dateLabel.text = String(stringInterpolationSegment: Int(timeAgo)) + ending
            }
            cell!.dateLabel.textColor = UIColor.whiteColor()
            cell!.scoreLabel.textColor = UIColor.whiteColor()
            cell!.scoreLabel.text = "[" + String(self.score[indexPath.row]) + "]"
            return cell!
        }
        
    }
    
    func longPressOptions(recognizer: UILongPressGestureRecognizer) {
        
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            var cellIndex = recognizer.view!.tag
            selectedToReportObject = voteObject[cellIndex]
            selectedToReportMessage = messages[cellIndex]
            
            let alert = SCLAlertView()
            alert.addButton("Report") {
                
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
            alert.addButton("Delete") {
                
            }
            
            alert.showEdit("Yes?", subTitle:"Choose:", closeButtonTitle: "Cancel")
        }

        else if (recognizer.state == UIGestureRecognizerState.Began) {
            //Do Whatever You want on Began of Gesture
            
        }
    }
    
    // MAIL
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["tarangalbert@gmail.com"])
        mailComposerVC.setSubject("Reporting for Inspirator")
        var body = String(stringInterpolationSegment: selectedToReportObject) + "\r\n" + "Problem:"
        mailComposerVC.setMessageBody(body, isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // FINISH MAIL
    
    func profileImageTapped(recognizer: UITapGestureRecognizer) {
        var imageIndex = recognizer.view!.tag
        selectedName = userArray[imageIndex]
        selectedScore = String(score[imageIndex])
        selectedParseObject = voteObject[imageIndex]
        performSegueWithIdentifier("profileView", sender: self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedName = userArray[indexPath.row]
        selectedScore = String(score[indexPath.row])
        selectedParseObject = voteObject[indexPath.row]
        selectedFirstPost = messages[indexPath.row]
        if let myObject = ParseObjectId[indexPath.row] as String? {
            selectedParseObjectId = myObject
        }
        //let destinationVC = profileVC()
        //destinationVC.name = selectedName
        performSegueWithIdentifier("showComments", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var recipients2 = [String]()
        if (segue.identifier == "profileView") { //pass data to VC
            var svc = segue.destinationViewController.topViewController as! profileVC
            println(selectedName)
            svc.name = selectedName
            svc.canChange = false
            svc.score = selectedScore
            svc.show = true
            //svc.profileObject =
        } else if (segue.identifier == "posting") {
            var svc = segue.destinationViewController.topViewController as! postingViewController
            svc.passedGroup = groupToQuery!
        } else if (segue.identifier == "showComments") { // get notified if you see comment section
            var currentUserId = PFUser.currentUser()?.objectId
            
            
            if var recipients = selectedParseObject!["recipients"] as? [String] {  //added to receiver array, real notification on comment adding in commentsVC
                if !contains(recipients, currentUserId!) {
                    println(PFUser.currentUser()?.objectId)
                    recipients.append(currentUserId!)
                    selectedParseObject!["recipients"] = recipients
                    recipients2 = recipients
                    // This will save both myPost and myComment
                    selectedParseObject!.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            
                            // update cell locally atleast and maybe not call self.retrieve
                        } else {
                            println("Couldn't subscribe!")
                            SCLAlertView().showWarning("Error Commenting", subTitle: "Check Your Internet Connection.")
                        }
                    }
                }
            } else {
                selectedParseObject!["recipients"] = [String]()
                var recipients3 = selectedParseObject!["recipients"] as? [String]
                recipients3?.append(currentUserId!)
                recipients2 = recipients3!
                selectedParseObject!["recipients"] = recipients2
                selectedParseObject!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        
                    } else {
                        println("Couldn't Vote!")
                        SCLAlertView().showWarning("Error Commenting", subTitle: "Check Your Internet Connection.")
                    }
                }
            }
            
            var svc = segue.destinationViewController.topViewController as! CommentsVC // nav controller in between
            
            if let parseID = selectedParseObjectId as String?{
                svc.name = selectedName
                svc.firstPost = selectedFirstPost
                svc.objectIDPost = parseID
                svc.recipients = recipients2
                println(recipients2)
            }
        }
    }
    
    func textView(textView: UITextView!, shouldInteractWithURL URL: NSURL!, inRange characterRange: NSRange) -> Bool {
        
        println("Link Selected!")
        return true
        
    }
    
    
}

