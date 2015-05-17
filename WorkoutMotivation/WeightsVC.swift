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
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var Qlabel: UILabel!
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var ImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        Qlabel.text = q1.getQuote()
        Qlabel.textColor = UIColor.greenColor()
        ImageView.image = UIImage(named: "Weights\(arc4random_uniform(10)).png")
        
    }
    
    func loadVideo() {
        let requestURL = NSURL(string: "https://www.youtube.com/watch?v=ZpwEHIL_UZ4")
        let request = NSURLRequest(URL: requestURL)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_ : UIWebView) {
        activity.startAnimating()
        NSLog("started")
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        activity.stopAnimating()
        NSLog("done")
    }
}
