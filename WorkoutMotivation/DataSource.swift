//
//  DataSource.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/15/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import Foundation
import UIKit

class DataSource{
    var motivate:[Motivate]
    
    init() {
        motivate = []
        let m1 = Motivate(title: "Cardio", videoId: "UpH7rm0cYbM", workoutText: "A calisthenic",color:  UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.5))
        motivate.append(m1)
        
        let m2 = Motivate(title: "Weights", videoId: "y-wV4Venusw", workoutText: "A wall sit", color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5))
        motivate.append(m2)
        
        let m3 = Motivate(title: "Programming", videoId: "Eh00_rniF8E", workoutText: "An exercise ", color: UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 0.5))
        motivate.append(m3)
        
        let m4 = Motivate(title: "Study", videoId: "2yOFvV-NSeY", workoutText: "A crunch ", color:UIColor(red: 0.3, green: 0.6, blue: 04, alpha: 0.5))
        motivate.append(m4)
        
        let m5 = Motivate(title: "Pure Motivation", videoId: "kM2FfDIwsao", workoutText: "To do a step-up ", color: UIColor(red: 0.2, green: 0.7, blue: 0.7, alpha: 0.5))
        //UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 79.0 / 255.0, alpha: 1)
        
        motivate.append(m5)
//        
//        let m6 = Motivate(title: "Squats", videoId: "mGvzVjuY8SY", workoutText: "Crouch ", color: UIColor.blueColor())
//        motivate.append(m6)
//        
//        let m7 = Motivate(title: "Triceps dips on a chair", videoId: "0326dy_-CzM", workoutText: "Triceps dips on a chair", color: UIColor.yellowColor())
//        motivate.append(m7)
        
    }
    
    func getMotivated() -> [Motivate]{
       return motivate
    }
    
}