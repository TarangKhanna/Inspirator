//
//  ProgrammingQuotes.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/17/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import Foundation
import UIKit

class ProgrammingQuotes {
    var quotes:[String] = ["To do what you believe is great work", "The pain of discipline is nothing like the pain of disappointment", "Shut up and train","I don’t care what you USED to bench", "Right now, your competition is training","Go Hard, or Go Home", "The pain you feel today is the strength you’ll feel tomorrow", "The resistance that you fight physically in the gym and the resistance that you fight in life can only build a strong character. – Arnold Schwarzenegger","Pain is weakness leaving the body", "The worst thing you can be is average", "EAT BIG, LIFT BIG, GET BIG!", "THE HARDEST THING ABOUT EARNING A TITLE IS THE ABILITY TO LIVE UP TO IT", "Doubt me, hate me, you’re the inspiration I need", "Be proud, but never satisfied", "Only you get out, what you put in"]
    func getQuote() -> String {
        let count = uint(quotes.count)
        let randomQ = Int(arc4random_uniform(count))
        print(randomQ)
        
        return quotes[randomQ]
    }
}

