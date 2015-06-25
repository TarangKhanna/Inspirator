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

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate,  floatMenuDelegate  {
    @IBOutlet var username: MKTextField!
    @IBOutlet var password: MKTextField!
    @IBOutlet var aboutYou: MKTextField!
    @IBOutlet var SignUpBtn: MKButton!
    
    override func viewWillAppear(animated: Bool) {
        SignUpBtn.center.x  -= view.bounds.width
        username.center.x -= view.bounds.width
        password.center.x -= view.bounds.width
        aboutYou.center.x -= view.bounds.width
    }
    
    func viewWillAppear() {
        SignUpBtn.center.x  -= view.bounds.width
        username.center.x -= view.bounds.width
        password.center.x -= view.bounds.width
        aboutYou.center.x -= view.bounds.width
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBG.png")!)
        let floatFrame:CGRect = (CGRectMake(UIScreen.mainScreen().bounds.size.width - 44 - 20, UIScreen.mainScreen().bounds.size.height - 44 - 20, 44, 44))
        // Do any additional setup after loading the view, typically from a nib.
        // self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.6, alpha: 0.5)
        let actionButton : VCFloatingActionButton = VCFloatingActionButton(frame: floatFrame, normalImage: UIImage(named: "plus.png"), andPressedImage: UIImage(named: "cross.png"), withScrollview: nil)
        //actionButton.normalImage = UIImage(named: "plus.png")!
        self.view.addSubview(actionButton)
        //actionButton.frame = floatFrame
        //actionButton.center = self.view.center
        actionButton.imageArray = ["fb-icon.png","twitter-icon.png","google-icon.png","linkedin-icon.png"]
        actionButton.labelArray = ["Facebook","Twitter","Google Plus","Linked in"]
        actionButton.delegate = self
        // No border, no shadow, floatingPlaceholderEnabled
        username.layer.borderColor = UIColor.clearColor().CGColor
        username.floatingPlaceholderEnabled = true
        username.placeholder = "Username.."
        username.tintColor = UIColor.MKColor.Blue
        username.rippleLocation = .Right
        username.cornerRadius = 0
        username.bottomBorderEnabled = true
        username.attributedPlaceholder = NSAttributedString(string:"Username..",
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        username.delegate = self
        
        password.layer.borderColor = UIColor.clearColor().CGColor
        password.floatingPlaceholderEnabled = true
        password.placeholder = "Password.."
        password.tintColor = UIColor.MKColor.Blue
        password.rippleLocation = .Right
        password.cornerRadius = 0
        password.bottomBorderEnabled = true
        password.attributedPlaceholder = NSAttributedString(string:"Password..",
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        password.delegate = self
        
        aboutYou.layer.borderColor = UIColor.clearColor().CGColor
        aboutYou.floatingPlaceholderEnabled = true
        aboutYou.placeholder = "Describe Yourself In A Few Words.."
        aboutYou.tintColor = UIColor.MKColor.Blue
        aboutYou.rippleLocation = .Right
        aboutYou.cornerRadius = 0
        aboutYou.bottomBorderEnabled = true
        aboutYou.attributedPlaceholder = NSAttributedString(string:"Describe Yourself In A Few Words..",
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        aboutYou.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            // self.performSegueWithIdentifier("showUsers", sender: self)
            
        }
        println("wfijbw")
        
    }
    
    func setBGColor() {
        let choose = arc4random_uniform(6)
        
        switch choose {
        case 0:
            self.view.backgroundColor = UIColor.blueColor()
        case 1:
            self.view.backgroundColor = UIColor.yellowColor()
        case 2:
            self.view.backgroundColor = UIColor.greenColor()
        case 3:
            self.view.backgroundColor = UIColor.blackColor()
        case 4:
            self.view.backgroundColor = UIColor.redColor()
        case 5:
            self.view.backgroundColor = UIColor.orangeColor()
        default:
            self.view.backgroundColor = UIColor.clearColor()
        }
     }
    
    @IBAction func signUp(sender: AnyObject) {
        signUp2()
    }
    
    func signUp2() {
        var user = PFUser()
        if username.text == "" || password.text == "" {
            SCLAlertView().showWarning("Sign Up Info", subTitle: "Please include your username and password")
        } else if self.aboutYou.text == ""{
            SCLAlertView().showWarning("Sign Up Info", subTitle: "Please include Something About You")
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
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    SCLAlertView().showWarning("SignUp Error", subTitle: errorString! as String)
                } else {
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
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
        imageToPost.image = image
        
    }
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        // profile pic
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Post")
        
        //post["message"] = message.text
        
        post["userId"] = PFUser.currentUser()!.objectId!
        
        post["username"] = PFUser.currentUser()?.username
        
        let imageData = UIImagePNGRepresentation(imageToPost.image)
        
        let imageFile = PFFile(name: "image.png", data: imageData)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock{(success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
                
                self.imageToPost.image = UIImage(named: "315px-Blank_woman_placeholder.svg.png")
                
                
            } else {
                
                self.displayAlert("Could not post image", message: "Please try again later")
                
            }
            
        }
        
    }
}
