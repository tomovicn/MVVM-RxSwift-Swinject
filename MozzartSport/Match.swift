//
//  Match.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import ObjectMapper

class Match: Mappable {
    var id: Int?
    var categoryId: Int?
    var tournamentId: Int?
    var homeTeam: Team?
    var guestTeam: Team?
    var matchCurrentTime: TimeInterval?
    var tournamentName: String?
    var categoryName: String?
    var winner: Bool?
    var started: TimeInterval?
    var periodStarted: TimeInterval?
    var matchTime: String?
    var status: String?
    var statusCode: Int?
    var score: MatchScore?
    var goals: Goals?
    var cardsGroup: CardsGroup?
    
    required init?(map: Map){
        
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

extension Match: Equatable {
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
}
