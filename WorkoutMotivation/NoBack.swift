//
//  NoBack.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/15/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class NoBack: UIViewController, floatMenuDelegate {
    @IBOutlet var textField4: MKTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        
        let floatFrame:CGRect = (CGRectMake(UIScreen.mainScreen().bounds.size.width - 44 - 20, UIScreen.mainScreen().bounds.size.height - 44 - 20, 44, 44))
        // Do any additional setup after loading the view, typically from a nib.
        // self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.6, alpha: 0.5)
        let actionButton : VCFloatingActionButton = VCFloatingActionButton()
        actionButton.normalImage = UIImage(named: "plus.png")!
       self.view.addSubview(actionButton)
        actionButton.frame = floatFrame
        //actionButton.center = self.view.center
        actionButton.imageArray = ["fb-icon.png","twitter-icon.png","google-icon.png","linkedin-icon.png"]
        actionButton.labelArray = ["Facebook","Twitter","Google Plus","Linked in"]
        actionButton.delegate = self
        
        // No border, no shadow, floatingPlaceholderEnabled
        textField4.layer.borderColor = UIColor.clearColor().CGColor
        textField4.floatingPlaceholderEnabled = true
        textField4.placeholder = "Type.."
        textField4.tintColor = UIColor.MKColor.Blue
        textField4.rippleLocation = .Right
        textField4.cornerRadius = 0
        textField4.bottomBorderEnabled = true
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
