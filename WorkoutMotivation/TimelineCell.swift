//
//  TimelineCell.swift
//  AutomatePortal
//
//  Created by Tarang Khanna on 2/28/15.
//  Copyright (c) 2015 Thacked. All rights reserved.
//


import Foundation
import UIKit
import Parse

class TimelineCell : MKTableViewCell {
    
    @IBOutlet var typeImageView : UIImageView!
    @IBOutlet var profileImageView : UIImageView!
    @IBOutlet var dateImageView : UIImageView!
    @IBOutlet var photoImageView : UIImageView?
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var postLabel : UILabel?
    @IBOutlet var dateLabel : UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var downVoteBtn: UIButton!
    var parseObject:PFObject?
    
    override func awakeFromNib() {
        
        dateImageView.image = UIImage(named: "clock")
        profileImageView.layer.cornerRadius = 30
        
        nameLabel.font = UIFont(name: "Avenir-Book", size: 16)
        nameLabel.textColor = UIColor.blackColor()
        
        postLabel?.font = UIFont(name: "Avenir-Book", size: 14)
        postLabel?.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        dateLabel.font = UIFont(name: "Avenir-Book", size: 14)
        dateLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        scoreLabel.font = UIFont(name: "Avenir-Book", size: 14)
        scoreLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        
        //var width = photoImageView.frame.size.width / 2
        //photoImageView?.layer.cornerRadius = width //10.0
        //photoImageView?.layer.borderColor = UIColor.whiteColor().CGColor
        //photoImageView?.layer.borderWidth = 3.0
        //photoImageView?.layer.borderWidth = 0.4
        //photoImageView?.layer.borderColor = UIColor(white: 0.92, alpha: 1.0).CGColor
    }
    
    @IBAction func upVote(sender: AnyObject) {
        
        println("Pressed")
        if(parseObject != nil) {
            if var votes:Int? = parseObject!.objectForKey("votes") as? Int {
                votes!++
                println("VOTING")
                parseObject!.setObject(votes!, forKey: "votes");
                parseObject!.saveInBackground();
                
                scoreLabel?.text = "\(votes!) votes";
            }
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if postLabel != nil {
            let label = postLabel!
            label.preferredMaxLayoutWidth = CGRectGetWidth(label.frame)
        }
    }
}