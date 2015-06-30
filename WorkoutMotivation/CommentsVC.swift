//
//  CommentsVCViewController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/24/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var commentField: MKTextField!
    
    var objectIDPost: String = ""
    var currentUserId = PFUser.currentUser()?.objectId
    var recipients = [String]()
    
    @IBAction func editingBegan(sender: UITextField) {
        //activeField = sender
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = true
        //self.navigationController?.ges
    }
    
    var kbHeight = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Connecting to Matrix...")
        commentField.layer.borderColor = UIColor.clearColor().CGColor
        commentField.placeholder = "Placeholder"
        commentField.tintColor = UIColor.MKColor.Red
        commentField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        // currentUserId = PFUser.currentUser()?.objectId
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var collection = self.childViewControllers[0] as! Comments
        var item = collection.collectionView(collection.collectionView!, numberOfItemsInSection: 0) - 1
        var lastItemIndex = NSIndexPath(forItem: item, inSection: 0)
        if lastItemIndex.row != -1 {
        collection.collectionView?.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        }
        
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                //self.animateTextField(true)
            }
       // }
        }
        animateViewMoving(true, moveValue: kbHeight)
    }
    
    func createComment() {
        
        if !commentField.text.isEmpty {
            
            var myComment = PFObject(className:"Comment")
            myComment["content"] = commentField.text
            var nameTemp =  PFUser.currentUser()?.username
            myComment["username"] = nameTemp
            myComment["parent"] = PFObject(withoutDataWithClassName:"Person", objectId: objectIDPost)
            myComment["fromObjectId"] = objectIDPost
            myComment.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    //
                    //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                    let query = PFInstallation.query()
                    if let query = query { // non intrusive
                        //query.whereKey("channels", equalTo: "suitcaseOwners")
                        query.whereKey("deviceType", equalTo: "ios")
                        var recipientsTemp = self.recipients
                        recipientsTemp.filter({$0 != PFUser.currentUser()?.objectId})
                        println("eqfef")
                        println(recipientsTemp)
                        query.whereKey("user", containedIn: recipientsTemp)
                        println("klnwerewr")
                        println(self.recipients)
                        
                        let iOSPush = PFPush()
                        iOSPush.setMessage("New Comment: " + self.commentField.text)
                        //iOSPush.setChannel("suitcaseOwners")
                        iOSPush.setQuery(query)
                        iOSPush.sendPushInBackground()
                    }
                    var viewCollection = self.childViewControllers[0] as? Comments
                    viewCollection!.retrieve()
                } else {
                    println("Couldn't Vote!")
                    SCLAlertView().showWarning("Error Commenting", subTitle: "Check Your Internet Connection.")
                }
                
            }
            commentField.text = ""
        } else {
            // empty comment -- alert?
        }
        // reload collectionview
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // self.animateTextField(false)
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                //self.animateTextField(true)
            }
        }
        animateViewMoving(false, moveValue: kbHeight)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "CommentsFlow") { //pass data to VC
            var svc = segue.destinationViewController as! Comments
            svc.parsePassedID = objectIDPost
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        createComment() // run with GDC
        self.view.endEditing(true)
        return false
    }
    
}
