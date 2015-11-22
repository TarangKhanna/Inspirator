//
//  LayoutController.swift
//  AutomatePortal
//
//  Created by Tarang Khanna on 2/28/15.
//  Copyright (c) 2015 Thacked. All rights reserved.
//

import UIKit

let reuseIdentifier = "collCell"
// in profileVC
// pass in data to the container- atleast username- then load their image and posts
class LayoutController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    var name2 : String = "" // passed from parent
    //var profileImageFile = PFFile()
    var downloadedImage2 = UIImage()
    var messages = [String]()
    var createdAt = [Int]()
    var duration : Int = 0
    var currentMessage = String()
    
    override func viewWillAppear(animated: Bool) {
        retrieve()
        
//        var queryUser = PFUser.query() as PFQuery?
//        queryUser!.findObjectsInBackgroundWithBlock {
//            (users: [AnyObject]?, error: NSError?) -> Void in
//            queryUser!.whereKey("username", equalTo: self.name2)
//            if error == nil {
//                // The find succeeded.
//                // Do something with the found users
//                if let users = users as? [PFObject] {
//                    for user in users {
//                        var user2:PFUser = user as! PFUser
//                        self.profileImageFile = user2["ProfilePicture"] as! PFFile
//                        self.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
//                            
//                            if let downloadedImage = UIImage(data: data!) {
//                                
//                                self.downloadedImage2 = downloadedImage
//                                //self.avatarImage.image = downloadedImage
//                                
//                            }
//                            
//                        }
//                        
//                        
//                    }
//                    //self.tableView.reloadData()
//                }
//            } else {
//                // Log details of the failure
//                println("Error: \(error!) \(error!.userInfo!)")
//            }
//        }
        
    }
    
    func retrieve() {
        
        
        if let query = PFQuery(className: "Person") as PFQuery? { //querying parse for user data
            _ = PFUser.currentUser()!.username
            
            //query.whereKey("username", EqualTo: usr!)
            
            
            query.orderByDescending("createdAt")
            query.whereKey("text", notEqualTo: "")
            query.whereKey("username", equalTo: name2)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                self.messages.removeAll(keepCapacity: false)
                self.createdAt.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject]  {
                    
                    for object in objects {
                        self.messages.append(object["text"] as! String)
                        let elapsedTime = CFAbsoluteTimeGetCurrent() - (object["startTime"] as! CFAbsoluteTime)
                        self.duration = Int(elapsedTime/60)
                        self.createdAt.append(self.duration)
                    }
                    self.collectionView?.reloadData()
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //currentMessage = messages[indexPath.row]
        //addCategory()
    }

    func addCategory() {
        
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PopUp") as! layoutPost
        popoverContent.message = currentMessage
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        //nav.popoverPresentationController!.delegate = implOfUIAPCDelegate
        let popover = nav.popoverPresentationController
        //popover.mess
        popoverContent.preferredContentSize = CGSizeMake(600,700)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(self.view.bounds.width/2,self.view.bounds.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        //cell.title.sizeToFit()
        cell.title2.text = messages[indexPath.row]
        cell.Image.image = downloadedImage2
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height/3))
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .None
    }

}
