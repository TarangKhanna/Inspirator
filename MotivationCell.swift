//
//  MotivationCell.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/14/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import Foundation
import UIKit

class MotivationCell: UITableViewCell {
    
    @IBOutlet weak var CellIndex: NSLayoutConstraint!
    @IBOutlet weak var CellText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}