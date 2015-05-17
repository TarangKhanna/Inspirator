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
        loadVideo()
    }
    
    func loadVideo() {
        let choose = arc4random_uniform(6)
        var requestURL = NSURL(string: "https://www.youtube.com/watch?v=ZpwEHIL_UZ4")
        switch choose {
        case 0:
            requestURL = NSURL(string: "https://www.youtube.com/watch?v=ZpwEHIL_UZ4")
        case 1:
            requestURL = NSURL(string: "https://www.youtube.com/watch?v=xDVoIVX1pAc&spfreload=10")
        case 2:
            requestURL = NSURL(string: "https://www.youtube.com/watch?v=Gvi05OMB5uA&spfreload=10")
        case 3:
            requestURL = NSURL(string: "https://www.youtube.com/watch?v=cWAEUMuxQvw&spfreload=10")
        case 4:
            requestURL = NSURL(string: "https://www.youtube.com/watch?v=Sp7253XSm-g&spfreload=10")
        case 5:
            requestURL = NSURL(string: "https://www.youtube.com/watch?v=fIswPMKKDRs")
        default:
            requestURL = NSURL(string: "https://www.youtube.com/watch?v=fIswPMKKDRs")
        }
        
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_ : UIWebView) {
        activity.startAnimating()
        //NSLog("started")
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        activity.stopAnimating()
        //NSLog("done")
    }
}
