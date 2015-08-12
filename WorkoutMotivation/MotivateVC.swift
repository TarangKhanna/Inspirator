//
//  ViewController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/13/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit
import Parse
import Social
import Foundation
var shown : Bool = false
let kSuccessTitle = "Congratulations"
let kErrorTitle = "Connection error"
let kNoticeTitle = "Notice"
let kWarningTitle = "Warning"
let kInfoTitle = "Randomized"
let kSubtitle = "Get Going!"

let kDefaultAnimationDuration = 2.0


class MotivateVC: UIViewController, UITableViewDelegate, UITableViewDataSource, floatMenuDelegate, BWWalkthroughViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    let manager = DataSource()
    var motivate = []
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var currentUser : String? = nil
    var currentUserId : String? = nil
    
    override func viewWillAppear(animated: Bool) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        //timeView.text = String(minutes)
        
        if let currentUser = PFUser.currentUser()?.username {
            currentUserId = PFUser.currentUser()?.objectId
        } else {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            if !userDefaults.boolForKey("walkthroughPresented") {
                
                showWalkthrough()
                
                userDefaults.setBool(true, forKey: "walkthroughPresented")
                userDefaults.synchronize()
            }
            performSegueWithIdentifier("signIn96", sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0") as! UIViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1") as! UIViewController
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")as! UIViewController
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3") as! UIViewController
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_zero)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        println("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.motivate = manager.getMotivated()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //self.navigationController?.navigationBar.hidden = false
        //let navBar = self.navigationController!.navigationBar
        //navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        //navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BG.png")!)
        //self.navigationController?.navigationBar.translucent = true

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "BG.png"), forBarMetrics: UIBarMetrics.Compact)
        self.navigationController?.navigationBar.tintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        //self.navigationController?.view.backgroundColor = UIColor.clearColor()
        //self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        var footer =  UIView(frame: CGRectZero)
        tableView.tableFooterView = footer
        tableView.tableFooterView!.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.clearColor()
        
        userDefaults.setValue(shown, forKey: "shown")
        userDefaults.synchronize()
        let floatFrame:CGRect = (CGRectMake(UIScreen.mainScreen().bounds.size.width - 44 - 20, UIScreen.mainScreen().bounds.size.height - 44 - 20, 44, 44))
        // self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.6, alpha: 0.5)
        let actionButton : VCFloatingActionButton = VCFloatingActionButton(frame: floatFrame, normalImage: UIImage(named: "plus.png"), andPressedImage: UIImage(named: "cross.png"), withScrollview: tableView)
        //actionButton.normalImage = UIImage(named: "plus.png")!
        self.view.addSubview(actionButton)
        actionButton.imageArray = ["fb-icon.png","twitter-icon.png","google-icon.png","linkedin-icon.png","profile-pic-1.jpg"]
        actionButton.labelArray = ["Facebook","Twitter","Google Plus","LinkedIn","About"]
        actionButton.delegate = self
        actionButton.hideWhileScrolling = true
    }
    
    func didSelectMenuOptionAtIndex(row : NSInteger) {
        println(row)
        if(row == 0) {
            //fb
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                //facebookSheet.setInitialText("#GetMotivated")
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
            //performSegueWithIdentifier("About", sender: self)
            //google+

        } else if(row == 3) {
            //LinkedIn
        } else if(row == 4){
            //performSegueWithIdentifier("About", sender: self)
            //new
             SCLAlertView().showInfo("About-Terms", subTitle: "http://tarangkhanna.github.io/InspiratorAppPage/terms.html")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.motivate.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let motivate1 = self.motivate[indexPath.row] as? Motivate
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? MotivationCell!
        cell!.MainText?.text = motivate1?.title
        cell!.backgroundColor = motivate1?.color
        cell!.MainIndex.text = "\(indexPath.row+1)"
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        //var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.greenColor()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0) {
            //WeightsVC.view.backgroundColor = UIColor.greenColor()
            //performSegueWithIdentifier("Cardio", sender: self)
            SCLAlertView().showInfo("In Test", subTitle: "This feature is uncertain, provide feedback by testing the Weight section!")
        } else if(indexPath.row == 1) {
            println(userDefaults.valueForKey("shown")!)
            var shown2: Bool = userDefaults.valueForKey("shown")!.boolValue
            if shown2 {
                println("TRUE!")
            } else {
                println("FALSE!!")
                // do something here when a highscore exists
                //SCLAlertView().showInfo(kInfoTitle, subTitle: kSubtitle)
                //shown = true
                userDefaults.setValue(true, forKey: "shown")
                userDefaults.synchronize()
            }
            //WeightsVC.view.backgroundColor = UIColor.greenColor()
            performSegueWithIdentifier("Weights", sender: self)
            
        } else if(indexPath.row == 2) {
            //performSegueWithIdentifier("Programming", sender: self)
            SCLAlertView().showInfo("In Test", subTitle: "This feature is uncertain, provide feedback by testing the Weight section!")
        } else if(indexPath.row == 3) {
            //performSegueWithIdentifier("Study", sender: self)
            SCLAlertView().showInfo("In Test", subTitle: "This feature is uncertain, provide feedback by testing the Weight section!")
        } else if(indexPath.row == 4) {
            //performSegueWithIdentifier("Pure", sender: self)
            SCLAlertView().showInfo("In Test", subTitle: "This feature is uncertain, provide feedback by testing the Weight section!")
        }
    }
    
    @IBAction func timelineShow(sender: AnyObject) {
        if PFUser.currentUser()?.username == nil {
           performSegueWithIdentifier("signIn2", sender: self)
        } else {
           performSegueWithIdentifier("timeline", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.tableView.contentInset = UIEdgeInsetsMake(0,0,70,0)
    }
    
    @IBAction func filterIt(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

