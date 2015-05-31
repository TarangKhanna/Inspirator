//
//  NoBack.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/15/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit
import Social

class SignUpVC: UIViewController, floatMenuDelegate , FBSDKLoginButtonDelegate, UITextFieldDelegate {
    @IBOutlet var username: MKTextField!
    @IBOutlet var password: MKTextField!
    @IBOutlet var aboutYou: MKTextField!
    @IBOutlet var SignUpBtn: MKButton!
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
        password.delegate = self
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            //            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            //            self.view.addSubview(loginView)
            //            loginView.center = self.view.center
            //            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            //            loginView.delegate = self
        }
        //setBGColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            // self.performSegueWithIdentifier("showUsers", sender: self)
            
        }
        
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
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData() // call this method anytime after a user has logged in by calling self.returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
            }
        })
    }
    
//    @IBAction func signIn(sender: AnyObject) {
//        if username.text == "" || password.text == "" {
//            SCLAlertView().showWarning("SignIn Info", subTitle: "Please include your username and password")
//        } else {
//            PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
//                (user: PFUser?, error: NSError?) -> Void in
//                if user != nil{
//                    println("logged in")
//                } else {
//                    // signUp()
//                    // wrong user or pass
//                }
//            }
//        }
//    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        signUp2()
    }
    
    func signUp2() {
        var user = PFUser()
        if username.text == "" || password.text == "" {
            SCLAlertView().showWarning("Sign Up Info", subTitle: "Please include your username and password")
        } else {
            user.username = self.username.text.lowercaseString
            user.password = self.password.text.lowercaseString
            //                user.email = "email@example.com"
            //                // other fields can be set just like with PFObject
            //                user["phone"] = "415-392-0202"
            //
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    println("ERROR")
                    SCLAlertView().showWarning("SignUp Info", subTitle: "The Username Is Already Taken")
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
    
}
