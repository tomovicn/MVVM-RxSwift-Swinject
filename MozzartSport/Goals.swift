//
//  Goal.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//
import ObjectMapper
import RealmSwift

class Goals: Object, Mappable {
    let homeTeam = List<Goal>()
    let guestTeam = List<Goal>()
    let byTime = List<Goal>()
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        var home: [Goal]?
        home <- map[Constants.Keys.Goal.homeTeam]
        if let home = home {
            for homeGoal in home {
                homeTeam.append(homeGoal)
            }
        }
        var guest: [Goal]?
        guest <- map[Constants.Keys.Goal.guestTeam]
        if let guest = guest {
            for guestGoal in guest {
                guestTeam.append(guestGoal)
            }
        }
        var time: [Goal]?
        time <- map[Constants.Keys.Goal.byTime]
        if let time = time {
            for timeGoal in time {
                byTime.append(timeGoal)
            }
        }
    }
    
}

class Goal: Object, Mappable {
    dynamic var player: String?
    dynamic var time = 0
    dynamic var team: String?
    dynamic var score: String?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        player <- map[Constants.Keys.Goal.player]
        time <- map[Constants.Keys.Goal.time]
        team <- map[Constants.Keys.Goal.team]
        score <- map[Constants.Keys.Goal.score]
    }
    
}
