//
//  Quotes.swift
//  WorkoutMotivation
//
//  Created by Tarang khanna on 5/16/15.
//  Copyright (c) 2015 Tarang khanna. All rights reserved.
//

import Foundation
import UIKit

class WeigthsQuotes {
    var quotes:[String] = ["To do what you believe is great work", "The pain of discipline is nothing like the pain of disappointment", "Shut up and train","I don’t care what you USED to bench", "Right now, your competition is training", ]
    func getQuote() -> String {
        let count = uint(quotes.count)
        let randomQ = Int(arc4random_uniform(count))
        print(randomQ)
        
        return quotes[randomQ]
    }
}