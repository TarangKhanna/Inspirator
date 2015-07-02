//
//  postingViewController.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 7/2/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import Foundation
import UIKit

class postingViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var commentTxtView: UITextView!
    var text = "Whats Up?"
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = true
    }
    
    override func viewDidLoad() {
        commentTxtView.text = text
        commentTxtView.textColor = UIColor.lightGrayColor()
        commentTxtView.delegate = self;
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        commentTxtView.text = ""
        commentTxtView.textColor = UIColor.blackColor()
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if(commentTxtView.text.length == 0){
            commentTxtView.textColor = UIColor.lightGrayColor()
            commentTxtView.text = text
            commentTxtView.resignFirstResponder()
        }
    }
}
