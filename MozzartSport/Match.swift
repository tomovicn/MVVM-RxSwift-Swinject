//
//  Match.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Match: Object, Mappable {
    dynamic var id = 0
    dynamic var categoryId = 0
    dynamic var tournamentId = 0
    dynamic var homeTeam: Team?
    dynamic var guestTeam: Team?
    dynamic var matchCurrentTime = 0.0
    dynamic var tournamentName: String?
    dynamic var categoryName: String?
    dynamic var winner = false
    dynamic var started = 0.0
    dynamic var periodStarted = 0.0
    dynamic var matchTime: String?
    dynamic var status: String?
    dynamic var statusCode = 0
    dynamic var score: MatchScore?
    dynamic var goals: Goals?
    dynamic var cardsGroup: CardsGroup?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map[Constants.Keys.Match.id]
        categoryId <- map[Constants.Keys.Match.categoryId]
        tournamentId <- map[Constants.Keys.Match.tournamentId]
        homeTeam <- map[Constants.Keys.Match.homeTeam]
        guestTeam <- map[Constants.Keys.Match.guestTeam]
        matchCurrentTime <- map[Constants.Keys.Match.currentTime]
        tournamentName <- map[Constants.Keys.Match.tournamentName]
        categoryName <- map[Constants.Keys.Match.categoryId]
        tournamentId <- map[Constants.Keys.Match.categoryName]
        started <- map[Constants.Keys.Match.started]
        periodStarted <- map[Constants.Keys.Match.periodStarted]
        matchTime <- map[Constants.Keys.Match.matchTime]
        status <- map[Constants.Keys.Match.status]
        statusCode <- map[Constants.Keys.Match.statusCode]
        score <- map[Constants.Keys.Match.score]
        goals <- map[Constants.Keys.Match.goals]
        cardsGroup <- map[Constants.Keys.Match.cards]
    }
    
}

extension Match {
    
    override func isEqual(_ object: Any?) -> Bool {
        if object is Match {
            if let match = object as? Match {
                return match.id == self.id
            }
        }
        return false
    }
}
