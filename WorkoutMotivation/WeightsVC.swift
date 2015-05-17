//
//  WeightsVC.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/16/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class WeightsVC: UIViewController {
    
    let q1 = WeigthsQuotes()
    
    @IBOutlet weak var Qlabel: UILabel!
    @IBOutlet var ImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        Qlabel.text = q1.getQuote()
        Qlabel.textColor = UIColor.greenColor()
        ImageView.image = UIImage(named: "Weights\(arc4random_uniform(10)).png")
    }
}
