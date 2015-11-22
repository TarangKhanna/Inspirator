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

class SocialVC: UIViewController, UIWebViewDelegate {
    //let q1 = ProgrammingQuotes()
    
    @IBOutlet var myProgressView: UIProgressView!
    
    @IBOutlet var myProgressView2: UIProgressView!
    @IBOutlet var webView1: UIWebView!
    @IBOutlet var webView2: UIWebView!
    var theBool: Bool = false
    var myTimer: NSTimer = NSTimer()
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
        // block adds - they take too much screen space- shouldStartLoadWithReques
        var requestURL = NSURL(string: "https://twitter.com/search?q=motivation&src=tyah")
        var request = NSURLRequest(URL: requestURL!)
        webView1.loadRequest(request)
        webView1.delegate = self
        
        requestURL = NSURL(string: "http://websta.me/tag/motivation")
        request = NSURLRequest(URL: requestURL!)
        webView2.loadRequest(request)
        webView2.delegate = self
        
    }
    
    func webView(_webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            var host = request.URL!.absoluteString
            print(request.URL!)
            if host.rangeOfString("websta.me") != nil || host!.rangeOfString("twitter.com") != nil {
                print("exists")
                return true
            }
            
            return false
    }
    
    func webViewDidStartLoad(_ : UIWebView) {
        // activity.startAnimating()
        funcToCallWhenStartLoadingYourWebview()
        //NSLog("started")
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        //activity.stopAnimating()
        //NSLog("done")
        funcToCallCalledWhenUIWebViewFinishesLoading()
    }
    func funcToCallWhenStartLoadingYourWebview() {
        self.myProgressView.progress = 0.0
        self.myProgressView2.progress = 0.0
        self.theBool = false
        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: "timerCallback", userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        self.theBool = true
    }
    
    func timerCallback() {
        if self.theBool {
            if self.myProgressView.progress >= 1 {
                self.myProgressView.hidden = true
                self.myTimer.invalidate()
            } else {
                self.myProgressView.progress += 0.1
            }
        } else {
            self.myProgressView.progress += 0.05
            if self.myProgressView.progress >= 0.95 {
                self.myProgressView.progress = 0.95
            }
        }
        if self.theBool {
            if self.myProgressView2.progress >= 1 {
                self.myProgressView2.hidden = true
                self.myTimer.invalidate()
            } else {
                self.myProgressView2.progress += 0.1
            }
        } else {
            self.myProgressView2.progress += 0.05
            if self.myProgressView2.progress >= 0.95 {
                self.myProgressView2.progress = 0.95
            }
        }
    }
}
