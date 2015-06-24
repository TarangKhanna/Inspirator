//
//  CollectionViewController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/23/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

//
//  FriendController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/19/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

let reuseIdentifier5 = "CellComments"

class Comments: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    
    var name2 : String = "" // passed from parent
    //var profileImageFile = PFFile()
    var downloadedImage2 = UIImage()
    var messages = [String]()
    var createdAt = [Int]()
    var duration : Int = 0
    var currentMessage = String()
    var imageFiles = [PFFile]()
    private let cellHeight: CGFloat = 150
    private let cellSpacing: CGFloat = 20
    
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
        self.automaticallyAdjustsScrollViewInsets = false
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBG.png")!)
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
        return 10 //imageFiles.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // currentMessage = messages[indexPath.row]
        // go to profile
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier5, forIndexPath: indexPath) as! CollectionViewCellComments
        //cell.title.sizeToFit()
       // cell.Image.clipsToBounds = true
       // cell.Image.layer.masksToBounds = true
       // cell.Image.layer.cornerRadius = cell.Image.layer.frame.size.width/2
        //let image42 = self.imageFiles[indexPath.row]
        //image42.getDataInBackgroundWithBlock { (data, error) -> Void in
          //  if let downloadedImage2 = UIImage(data: data!) {
                //cell.Image.image = downloadedImage2
            //}
        //}
        
        cell.nameBtn.setTitle("Name Here", forState: UIControlState.Normal) //name[indexPath.row]
        cell.title.text = "Comments Here" //messages[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds) - cellSpacing, cellHeight)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 5, 10, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .None
    }
    
    
}
