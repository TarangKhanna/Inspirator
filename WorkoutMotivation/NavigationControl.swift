//
//  NavigationControl.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/15/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class NavigationControl: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let navBar = self.navigationController!.navigationBar
        //navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        //navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        // Status bar white font
        //self.navigationBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 0.2)
        self.navigationBar.tintColor = UIColor.redColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        //self.navigationBar.translucent = true
       // self.navigationBar.shadowImage =
    }
}