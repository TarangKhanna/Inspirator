//
//  Motivate.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/15/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import Foundation
import UIKit

class Motivate {
    var videoId: String!
    var title: String!
    var workoutText: String!
    var color: UIColor!
    
    init(title: String, videoId: String, workoutText: String, color: UIColor){
        self.videoId = videoId
        self.title = title
        self.workoutText = workoutText
        self.color = color
    }
    
}