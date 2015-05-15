//
//  ViewController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/13/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.view.backgroundColor = self.navigationController!.navigationBar.barTintColor

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

