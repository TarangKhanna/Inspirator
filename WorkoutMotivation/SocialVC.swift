//
//  SocialVC.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/21/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//
//
//  Pure.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/18/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//
import UIKit

class SocialVC: UIViewController {
    //let q1 = ProgrammingQuotes()
    
    @IBOutlet var webView1: UIWebView!
    @IBOutlet var webView2: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        //Qlabel.text = q1.getQuote()
        //Qlabel.textColor = UIColor.greenColor()
        //ImageView.image = UIImage(named: "Weights\(arc4random_uniform(10)).png")
        loadSocial()
    }
    
    func loadSocial() {
        //let choose = arc4random_uniform(6)
        var requestURL = NSURL(string: "https://twitter.com/search?q=motivation&src=tyah")
        var request = NSURLRequest(URL: requestURL!)
        webView1.loadRequest(request)
        
        requestURL = NSURL(string: "http://websta.me/tag/motivation")
        request = NSURLRequest(URL: requestURL!)
        webView2.loadRequest(request)
        
    }
    
    func webViewDidStartLoad(_ : UIWebView) {
       // activity.startAnimating()
        //NSLog("started")
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        //activity.stopAnimating()
        //NSLog("done")
    }
}

