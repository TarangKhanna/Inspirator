//
//  NoBack.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/15/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit
import Social
import Parse

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate    {
    
    @IBOutlet var username: MKTextField!
    @IBOutlet var password: MKTextField!
    @IBOutlet var aboutYou: MKTextField!
    @IBOutlet var SignUpBtn: MKButton!
    
    
    @IBOutlet weak var dialogView: DesignableView!
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBG.png")!)
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "signUpBG")!)
        // No border, no shadow, floatingPlaceholderEnabled
        username.layer.borderColor = UIColor.clearColor().CGColor
        username.floatingPlaceholderEnabled = true
        username.placeholder = "Username"
        username.tintColor = UIColor.MKColor.Blue
        username.rippleLocation = .Right
        username.cornerRadius = 0
        username.bottomBorderEnabled = true
        username.attributedPlaceholder = NSAttributedString(string:"Username",
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        username.delegate = self
        
        password.layer.borderColor = UIColor.clearColor().CGColor
        password.floatingPlaceholderEnabled = true
        password.placeholder = "Password"
        password.tintColor = UIColor.MKColor.Blue
        password.rippleLocation = .Right
        password.cornerRadius = 0
        password.bottomBorderEnabled = true
        password.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        password.delegate = self
        
        aboutYou.layer.borderColor = UIColor.clearColor().CGColor
        aboutYou.floatingPlaceholderEnabled = true
        aboutYou.placeholder = "Few words about you"
        aboutYou.tintColor = UIColor.MKColor.Blue
        aboutYou.rippleLocation = .Right
        aboutYou.cornerRadius = 0
        aboutYou.bottomBorderEnabled = true
        aboutYou.attributedPlaceholder = NSAttributedString(string:"Few words about you",
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        aboutYou.delegate = self
    }
    
    @IBAction func signUp(sender: AnyObject) {
        self.view.showLoading()
        signUp2()
    }
    
    func signUp2() {
        var user = PFUser()
        if username.text == "" || password.text == "" {
            SCLAlertView().showWarning("Sign Up Info", subTitle: "Please include your username and password")
            self.view.hideLoading()
        } else if self.aboutYou.text == ""{
            SCLAlertView().showWarning("Sign Up Info", subTitle: "Please include Something About You")
            self.view.hideLoading()
        } else {
            
            user.username = self.username.text.lowercaseString
            user.password = self.password.text.lowercaseString
            user["AboutYou"] = self.aboutYou.text
            let imageData = UIImagePNGRepresentation(imageToPost.image)
            
            let imageFile = PFFile(name: "image.png", data: imageData)
            
            user["ProfilePicture"] = imageFile
            //                user.email = "email@example.com"
            //                // other fields can be set just like with PFObject
            //                user["phone"] = "415-392-0202"
            //
            //var collection = self.childViewControllers[0] as! Comments
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    SCLAlertView().showWarning("SignUp Error", subTitle: errorString! as String)
                    self.view.hideLoading()
                    self.dialogView.animation = "shake"
                    self.dialogView.animate()
                } else {
                    self.view.hideLoading()
                    println("Signed Up!!")
                    self.performSegueWithIdentifier("signedUp2", sender: self)
                    SCLAlertView().showInfo("Signed Up", subTitle: "Let's Get Going!", closeButtonTitle: "Ok", duration: 2)
                }
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //println("KFEVWKVFUWEL")
        self.view.endEditing(true)
        return false
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
            //LinkedIn
        } else if(row == 4) {
            //new
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageToPost: AvatarImageView!
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(true, completion:nil)
        println(image)
        imageToPost.image = image
        
    }
    
}



