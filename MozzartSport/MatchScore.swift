//
//  Score.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import ObjectMapper

class MatchScore: Mappable {
    var current: Score?
    var halfTime: Score?
    var normalTime: Score?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        current <- map[Constants.Keys.Score.current]
        halfTime <- map[Constants.Keys.Score.halfTime]
        normalTime <- map[Constants.Keys.Score.normalTime]
    }
    
}

class Score: Mappable {
    var homeTeam: Int?
    var guestTeam: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        homeTeam <- map[Constants.Keys.Score.homeTeam]
        guestTeam <- map[Constants.Keys.Score.guestTeam]
    }
    
}
