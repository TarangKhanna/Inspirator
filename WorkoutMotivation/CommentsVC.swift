//
//  CommentsVCViewController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 6/24/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var commentField: UITextField!
    var activeField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBAction func editingBegan(sender: UITextField) {
        //activeField = sender
    }
    var kbHeight = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        commentField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                //self.animateTextField(true)
            }
        }
        animateViewMoving(true, moveValue: kbHeight)
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
//    func textFieldDidBeginEditing(textField: UITextField) {
//       let frame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
//        animateViewMoving(true, moveValue: keybo)
//        println("fwqefew")
//    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        animateViewMoving(false, moveValue: 250)
//    }
    
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
        self.view.endEditing(true)
        return false
    }

}
