//
//  loginVC.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/21/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class loginVC: UIViewController,floatMenuDelegate, UITextFieldDelegate  {
    
    @IBOutlet var username: MKTextField!
    
    @IBOutlet var password: MKTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "loginBG2.png")!)
        let floatFrame:CGRect = (CGRectMake(UIScreen.mainScreen().bounds.size.width - 44 - 20, UIScreen.mainScreen().bounds.size.height - 44 - 20, 44, 44))
        // Do any additional setup after loading the view, typically from a nib.
        //self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.6, alpha: 0.5)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
        @IBAction func signIn(sender: AnyObject) {
            if username.text == "" || password.text == "" {
                SCLAlertView().showWarning("SignIn Info", subTitle: "Please include your username and password")
            } else {
                PFUser.logInWithUsernameInBackground(username.text.lowercaseString, password: password.text.lowercaseString) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil{
                        println("logged in")
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
}