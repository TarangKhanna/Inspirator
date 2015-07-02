//
//  TimelineViewCell.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 7/3/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import UIKit

class TimelineViewCell: UITableViewCell {
    
    
    @IBOutlet var typeImageView : UIImageView!
    @IBOutlet var profileImageView : UIImageView!
    @IBOutlet var dateImageView : UIImageView!
    @IBOutlet var photoImageView : UIImageView?
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var postLabel : UILabel?
    @IBOutlet var dateLabel : UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var upVoteBtn: UIButton!
    @IBOutlet var downVoteBtn: UIButton!
    
    @IBAction func upVoteCell(sender: AnyObject) {
        
    }
    
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
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if postLabel != nil {
            let label = postLabel!
            label.preferredMaxLayoutWidth = CGRectGetWidth(label.frame)
        }
        
        if scoreLabel != nil {
            let label = scoreLabel!
            label.preferredMaxLayoutWidth = CGRectGetWidth(label.frame)
        }
    }
}
