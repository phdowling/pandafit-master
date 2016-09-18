//
//  Panda.swift
//  PandaFit
//
//  Created by Felix Sonntag on 17/09/16.
//  Copyright © 2016 Felix Sonntag. All rights reserved.
//

import UIKit

enum Mood {
    case ecstatic
    case happy
    case content
    case angry
    case dying
}

class Panda: NSObject, NSCoding {
    
    var name: String
    var score: Int = 50
    var mood: Mood
    
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
        self.mood = Panda.moodForScore(score: score)
        
    }
    
    init(name: String, score: Int, mood: Mood) {
        self.name = name
        self.score = score
        self.mood = mood
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeInt32(forKey: "score")
        guard let name = aDecoder.decodeObject(forKey: "name") as? String
        else {
            return nil
        }
        self.init(name:name, score: Int(score))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.score, forKey: "score")
        
    }

    class func moodForScore(score: Int) -> Mood {
        var mood: Mood? = nil
        switch score {
        case let x where x < 20:
            mood = .dying
        case let x where x < 40:
            mood = .angry
        case let x where x < 60:
            mood = .content
        case let x where x < 80:
            mood = .happy
        case let x where x >= 80:
            mood = .ecstatic
        default:
            print("Warning: couldn't get a valid value for the score: \(score)")
            mood = .content
        }
        return mood!
    }
    
}
