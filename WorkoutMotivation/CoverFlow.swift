//
//  CoverFlow.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/26/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

let reuseIdentifier10 = "CoverFlow"

class CoverFlow: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    
    var name2 : String = "" // passed from parent
    //var profileImageFile = PFFile()
    var downloadedImage2 = UIImage()
    var messages = [String]()
    var createdAt = [Int]()
    var duration : Int = 0
    var currentMessage = String()
    var imageFiles = [PFFile]()
    
    override func viewWillAppear(animated: Bool) {
        retrieve()
        println("fwffwefew")
        
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
        self.imageFiles.removeAll(keepCapacity: false)
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
                        self.imageFiles.append(user2["ProfilePicture"] as! PFFile)
                        //self.imageFiles.append(user2["ProfilePictue"] as! PFFile)
                        
                    }
                }
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println(name2)
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
        return imageFiles.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // currentMessage = messages[indexPath.row]
        // go to profile
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier10, forIndexPath: indexPath) as! CollectionViewCell2
        //cell.title.sizeToFit()
//        cell.Image.clipsToBounds = true
//        cell.Image.layer.masksToBounds = true
//        cell.Image.layer.cornerRadius = cell.Image.layer.frame.size.width/2
        let image42 = self.imageFiles[indexPath.row]
        image42.getDataInBackgroundWithBlock { (data, error) -> Void in
            if let downloadedImage2 = UIImage(data: data!) {
                cell.Image.image = downloadedImage2
            }
        }
        //if indexPath.row == 0
        //cell.Image.image = UIImage(named: "BG.png")
        
        
        //cell.title.text = messages[indexPath.row]
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        println(self.view.frame.size)
        return CGSizeMake(self.view.frame.size.width, (self.view.frame.size.height - 10))
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .None
    }
    
    
}
