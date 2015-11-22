//
//  loginVC.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/21/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit
import Social

class loginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var username: MKTextField!
    
    @IBOutlet var signInBtn: MKButton!
    @IBOutlet var password: MKTextField!
    
    @IBOutlet var signUpBtn: MKButton!
    
    
    
    override func viewWillAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil || PFUser.currentUser() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            self.performSegueWithIdentifier("loggedIn2", sender: self)
        }
    }
    // Facebook Delegate Methods
    
    @IBAction func FBlogIn(sender: AnyObject) {
        //handle login/logout via the Parse SDK
        let permissions = [ "public_profile", "email", "user_friends" ]
        if PFUser.currentUser() != nil {
            PFUser.logOutInBackgroundWithBlock({ (_) -> Void in
                print("logged out")//the button will now refresh although I noticed a small delay 1/2 seconds
            })
        }
        else {
            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
                if let user = user {
                    if user.isNew {
                        print("User signed up and logged in through Facebook!")
                        self.returnUserData()
                        self.performSegueWithIdentifier("loggedIn2", sender: self)
                    } else {
                        print("User logged in through Facebook!")
                        self.returnUserData()
                        self.performSegueWithIdentifier("loggedIn2", sender: self)
                    }
                } else {
                    print("Uh oh. The user cancelled the Facebook login.")
                }
            })
        }
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            self.performSegueWithIdentifier("loggedIn2", sender: self)
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                if let dict = result as? Dictionary<String, AnyObject>{
                    var name:String = dict["name"] as AnyObject? as! String
                    var saferName = name.lowercaseString
                    print("User Name is: \(name)")
                    let facebookID:String = dict["id"] as AnyObject? as! String
                    let email:String = dict["email"] as AnyObject? as! String
                    let aboutYou:String = ""
                    print(dict)
                    print("jhvwev")
                    let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                    let bioURL = "https://graph.facebook.com/\(facebookID)/fields=bio"
                    var URLRequest = NSURL(string: pictureURL)
                    var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                    var URLRequest2 = NSURL(string: bioURL)
                    var URLRequestNeeded2 = NSURLRequest(URL: URLRequest2!)
                    
                    let session = NSURLSession.sharedSession()
                    let urlString = "https://api.yoursecureapiservergoeshere.com/1/whatever"
                    let url = NSURL(string: urlString)
                    let request = NSURLRequest(URL: url!)
                    let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                        print("done, error: \(error)")
                    }
                    
                    
                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            var picture = PFFile(data: data)
                            PFUser.currentUser()!.setObject(picture, forKey: "ProfilePicture")
                            PFUser.currentUser()!.saveInBackground()
                        }
                        else {
                            print("Error: \(error.localizedDescription)")
                        }
                    })
                    
                    NSURLConnection.sendAsynchronousRequest(URLRequestNeeded2, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            //var aboutYou = PFUser.currentUser(data: data)
                            //PFUser.currentUser()!.setObject(aboutYou, forKey: "username")
                            //PFUser.currentUser()!.saveInBackground()
                            print("ergg")
                            print(data)
                            print(response)
                        }
                        else {
                            print("Error: \(error.localizedDescription)")
                        }
                    })
                    
                    PFUser.currentUser()!.setValue(saferName, forKey: "username")
                    PFUser.currentUser()!.setValue(email, forKey: "email")
                    PFUser.currentUser()!.setValue(aboutYou, forKey: "AboutYou")
                    PFUser.currentUser()!.saveInBackground()
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        signInBtn.maskEnabled = false
//        signInBtn.ripplePercent = 0.5
//        signInBtn.backgroundAniEnabled = false
//        signInBtn.rippleLocation = .Center
//        
//        signUpBtn.maskEnabled = false
//        signUpBtn.ripplePercent = 0.5
//        signUpBtn.backgroundAniEnabled = false
//        signUpBtn.rippleLocation = .Center
        //self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBG2.png")!)
        
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
        //self.view.backgroundColor = UIColor.orangeColor()
        password.attributedPlaceholder = NSAttributedString(string:"Password..",
            attributes:[NSForegroundColorAttributeName: UIColor.orangeColor()])
        password.delegate = self
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
        @IBAction func signIn(sender: AnyObject) {
            if username.text == "" || password.text == "" {
                SCLAlertView().showWarning("SignIn Info", subTitle: "Please include your username and password")
            } else {
                PFUser.logInWithUsernameInBackground(username.text!.lowercaseString, password: password.text!.lowercaseString) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil{
                        print("logged in")
                        self.performSegueWithIdentifier("loggedIn2", sender: self)
                        SCLAlertView().showInfo("Signed In", subTitle: "Let's Get Going!", closeButtonTitle: "Ok", duration: 2)
                    } else {
                        // signUp()
                        SCLAlertView().showWarning("SignIn Info", subTitle: "Incorrect Username or Password")
                        // wrong user or pass
                    }
                }
            }
        }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didSelectMenuOptionAtIndex(row : NSInteger) {
        print(row)
        if(row == 0) {
            //fb
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
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
                let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
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