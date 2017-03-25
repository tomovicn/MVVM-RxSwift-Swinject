//
//  Goal.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import ObjectMapper

class Goals: Mappable {
    var homeTeam: [Goal]?
    var guestTeam: [Goal]?
    var byTime: [Goal]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        homeTeam <- map[Constants.Keys.Goal.homeTeam]
        guestTeam <- map[Constants.Keys.Goal.guestTeam]
        byTime <- map[Constants.Keys.Goal.byTime]
    }
    
}

class Goal: Mappable {
    var player: String?
    var time: Int?
    var team: String?
    var score: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        player <- map[Constants.Keys.Goal.player]
        time <- map[Constants.Keys.Goal.time]
        team <- map[Constants.Keys.Goal.team]
        score <- map[Constants.Keys.Goal.score]
    }
    
}
