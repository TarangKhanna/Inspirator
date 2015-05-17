//
//  WeightsVC.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/16/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class WeightsVC: UIViewController {
    
    
    @IBOutlet weak var Qtext: UITextView!
    let q1 = WeigthsQuotes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        Qtext.text = q1.getQuote()
        Qtext.textColor = UIColor.greenColor()
        Qtext.backgroundColor = self.view.backgroundColor
    }
}
