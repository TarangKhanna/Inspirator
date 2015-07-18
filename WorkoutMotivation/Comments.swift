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

class Comments: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
    var firstPostComment = String()
    var parsePassedID : String = ""
    var name2 : String = "" // passed from parent
    //var profileImageFile = PFFile()
    var downloadedImage2 = UIImage()
    var messages = [String]()
    var createdAt = [Int]()
    var duration : Int = 0
    var currentMessage = String()
    var imageFiles = [PFFile]()
    private let cellHeight: CGFloat = 110
    private let cellSpacing: CGFloat = 20
    var commentView: UITextView?
    var footerView: UIView?
    var score = [Int]()
    var userArray: [String] = []
    
    
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
        
        if var query = PFQuery(className: "Comment") as PFQuery? { //querying parse for user data
            query.orderByAscending("createdAt")
            query.whereKey("fromObjectId", equalTo: parsePassedID)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                SwiftSpinner.hide()
                //UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if error != nil {
                    println("No Internet")
                    //self.statusLabel.text = "No Internet. Try refreshing."
                }
                //self.containsImage.removeAll(keepCapacity: false)
                //self.imageFiles.removeAll(keepCapacity: false)
                self.messages.removeAll(keepCapacity: false)
                self.userArray.removeAll(keepCapacity: false)
                //self.score.removeAll(keepCapacity: false)
                self.messages.append(self.firstPostComment)
                self.userArray.append(self.name2)
                self.createdAt.removeAll(keepCapacity: false)
                //self.voteObject.removeAll(keepCapacity: false)
                //self.votedArray.removeAll(keepCapacity: false)
                //self.ParseObjectId.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject]  {
                    for object in objects {
//                        if let imageFile42 = object["imageFile"] as? PFFile{
//                            self.imageFiles.append(imageFile42)
//                            self.containsImage.append(true)
//                            println(imageFile42)
//                            println("iuhewbd")
//                        } else {
//                            self.imageFiles.append(PFFile())
//                            self.containsImage.append(false)
//                            println("jkbdj")
//                        }
                        //self.voteObject.append(object)
                        //self.ParseObjectId.append((object.objectId! as String?)!)
                        self.messages.append(object["content"] as! String)
                        self.userArray.append(object["username"] as! String)
                        //self.score.append(object["score"] as! Int)
                        //let elapsedTime = CFAbsoluteTimeGetCurrent() - (object["startTime"] as! CFAbsoluteTime)
                        //self.duration = Int(elapsedTime/60)
                        //self.createdAt.append(self.duration)
                    }
                    self.collectionView!.reloadData()
                }
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // No border, no shadow, floatPlaceHolderDisabled
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:", name:"load", object: nil)
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
        return messages.count //imageFiles.count
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
        var name = userArray[indexPath.row]
        name.replaceRange(name.startIndex...name.startIndex, with: String(name[name.startIndex]).capitalizedString)
        cell.nameBtn.setTitle(name, forState: UIControlState.Normal) //name[indexPath.row]
        cell.textView.text = messages[indexPath.row] // comment
        //cell.textView.text
        return cell
    }
    
    
//    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        println("Footerview")
//        footerView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 100))
//        footerView?.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
//        commentView = UITextView(frame: CGRect(x: 10, y: 5, width: collectionView.bounds.width - 80 , height: 40))
//        commentView?.backgroundColor = UIColor.whiteColor()
//        commentView?.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
//        commentView?.layer.cornerRadius = 2
//        commentView?.scrollsToTop = true
//        
//        footerView?.addSubview(commentView!)
//        let button = UIButton(frame: CGRect(x: collectionView.bounds.width - 65, y: 10, width: 60 , height: 30))
//        button.setTitle("Reply", forState: UIControlState.Normal)
//        button.backgroundColor = UIColor(red: 155.0/255, green: 189.0/255, blue: 113.0/255, alpha: 1)
//        button.layer.cornerRadius = 5
//        button.addTarget(self, action: "reply", forControlEvents: UIControlEvents.TouchUpInside)
//        footerView?.addSubview(button)
//        commentView?.delegate = self
//        println(self.collectionView!.frame)
//        println(self.footerView?.frame)
//        println(self.footerView?.bounds)
//        return footerView
//    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 5, 10, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
   

}
