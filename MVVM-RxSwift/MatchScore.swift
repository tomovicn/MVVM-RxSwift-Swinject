//
//  Score.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import ObjectMapper
import RealmSwift

class MatchScore: Object, Mappable {
    dynamic var current: Score?
    dynamic var halfTime: Score?
    dynamic var normalTime: Score?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        current <- map[Constants.Keys.Score.current]
        halfTime <- map[Constants.Keys.Score.halfTime]
        normalTime <- map[Constants.Keys.Score.normalTime]
    }
    
}

class Score: Object, Mappable {
    dynamic var homeTeam = 0
    dynamic var guestTeam = 0
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        homeTeam <- map[Constants.Keys.Score.homeTeam]
        guestTeam <- map[Constants.Keys.Score.guestTeam]
    }
    
}
