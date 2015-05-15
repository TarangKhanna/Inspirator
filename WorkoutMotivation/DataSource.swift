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
        let m1 = Motivate(title: "Jumping Jacks", videoId: "UpH7rm0cYbM", workoutText: "A calisthenic jump done from a standing position with legs together and arms at the sides to a position with the legs apart and the arms over the head.",color:  UIColor.redColor())
        motivate.append(m1)
        
        let m2 = Motivate(title: "Wall Sits", videoId: "y-wV4Venusw", workoutText: "A wall sit, also known as a Roman Chair, is an exercise done to strengthen the quadriceps muscles. It is characterized by the two right angles formed by the body, one at the hips and one at the knees.", color: UIColor.blueColor())
        motivate.append(m2)
        
        
        let m4 = Motivate(title: "Abdominal Crunches", videoId: "2yOFvV-NSeY", workoutText: "A crunch begins with lying face up on the floor with knees bent. The movement begins by curling the shoulders towards the pelvis. The hands can be behind or beside the neck or crossed over the chest. Injury can be caused by pushing against the head or neck with hands.", color: UIColor.purpleColor())
        motivate.append(m4)
        
        let m3 = Motivate(title: "Push Ups", videoId: "Eh00_rniF8E", workoutText: "An exercise in which a person lies facing the floor and, keeping their back straight, raises their body by pressing down on their hands.", color: UIColor.blueColor())
        motivate.append(m3)
        
        
        let m5 = Motivate(title: "Step-ups onto a chair", videoId: "kM2FfDIwsao", workoutText: "To do a step-up, position your chair in front of your body. Stand with your feet about hip-width apart, arms at your sides. Step up onto the seat with one foot, pressing down while bringing your other foot up next to it. ", color: UIColor.greenColor())
        motivate.append(m5)
        
        let m6 = Motivate(title: "Squats", videoId: "mGvzVjuY8SY", workoutText: "Crouch or sit with one's knees bent and one's heels close to or touching one's buttocks or the back of one's thighs.", color: UIColor.blueColor())
        motivate.append(m6)
        
        let m7 = Motivate(title: "Triceps dips on a chair", videoId: "0326dy_-CzM", workoutText: "Triceps dips on a chair", color: UIColor.yellowColor())
        motivate.append(m7)
        
    }
    
    func getMotivated() -> [Motivate]{
       return motivate
    }
    
}