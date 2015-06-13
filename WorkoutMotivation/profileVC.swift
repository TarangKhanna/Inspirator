//
//  profileVC.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/29/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//


import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class profileVC: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var profileName: UILabel!
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var aboutYouLabel: UILabel!
    var name : String = ""
    var aboutYou : String = ""
    var score: String = ""
    var profileImageFile = PFFile()
    var blurredHeaderImageView:UIImageView?
    override func viewWillAppear(animated: Bool) {
        aboutYouLabel.text = ""
        scoreLabel.text = score
        profileName.text = name
        var queryUser = PFUser.query() as PFQuery?
        queryUser!.findObjectsInBackgroundWithBlock {
            (users: [AnyObject]?, error: NSError?) -> Void in
            //queryUser!.orderByDescending("createdAt")
            //queryUser!.whereKey("username", equalTo: self.name)
            if error == nil {
                //println("Successfully retrieved \(users!.count) users.")
                // Do something with the found users
                if let users = users as? [PFObject] {
                    for user in users {
                        var user2:PFUser = user as! PFUser
                        if user2.username == self.name {
                            self.aboutYouLabel.text = user2["AboutYou"] as? String
                            println("wfkjbf")
                            println((user2["AboutYou"] as? String)!)
                            self.profileImageFile = user2["ProfilePicture"] as! PFFile
                            self.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                                
                                if let downloadedImage = UIImage(data: data!) {
                                    self.avatarImage.image = downloadedImage
                                }
                                
                            }
                            //self.imageFiles.append(user2["ProfilePictue"] as! PFFile)
                        }
                        //self.tableView.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "zoomIn") { //pass data to VC
            var svc = segue.destinationViewController as! LayoutController;
            svc.name2 = name
            //NSThread.sleepForTimeInterval(10)
            
            //get profile pic
            var queryUser = PFUser.query() as PFQuery?
            queryUser!.findObjectsInBackgroundWithBlock {
                (users: [AnyObject]?, error: NSError?) -> Void in
                queryUser!.orderByDescending("createdAt")
                queryUser!.whereKey("username", equalTo: self.name)
                if error == nil {
                    //println("Successfully retrieved \(users!.count) users.")
                    // Do something with the found users
                    if let users = users as? [PFObject] {
                        for user in users {
                            var user2:PFUser = user as! PFUser
                            if user2.username == self.name {
                                self.profileImageFile = user2["ProfilePicture"] as! PFFile
                                self.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                                    
                                    if let downloadedImage = UIImage(data: data!) {
                                        
                                        svc.downloadedImage2 = downloadedImage
                                        
                                    }
                                    
                                }
                                //self.imageFiles.append(user2["ProfilePictue"] as! PFFile)
                                
                            }
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
    
    override func viewDidAppear(animated: Bool) {
        
        // Header - Image
        
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "header_bg")
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = UIImage(named: "header_bg")?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
        headerBlurImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
        
        headerLabel.text = "You Broke it"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            //  ------------ Blur
            
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if avatarImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        
        header.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
    }
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .None
    }
    
}