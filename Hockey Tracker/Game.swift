//
//  Game.swift
//  Hockey Tracker
//
//  Created by Prerak Patel on 2020-11-09.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import UIKit

class Game: Equatable, Codable {
    
    // Oppenent Name
    var opponent: String
    // Total number of Goals
    var goals: Int {
        didSet {
            if goals < 0 {
                goals = 0
            }
        }
    }
    // Total number of assists
    var assists: Int {
        didSet {
            if assists < 0 {
                assists = 0
            }
        }
    }
    // points = goals + assists
    var points: Int {
        return goals + assists
    }
    var plusMinus: Int
    var gameDate: Date
    
    // Initializer to give raw data when new object is created
    init(){
        opponent = ""
        goals = 0
        assists = 0
        plusMinus = 0
        gameDate = Date()
    }
    
    // Overridiing == method of Equatable to find the right object that was added
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.opponent == rhs.opponent && lhs.goals == rhs.goals && lhs.assists == rhs.assists && lhs.points == rhs.points && lhs.plusMinus == rhs.plusMinus && lhs.gameDate == rhs.gameDate
    }
    
}
