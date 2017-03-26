//
//  MatchCast.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import ObjectMapper
import RealmSwift

class MatchCast: Match {
    
    var comments: [String : Comment]?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        comments <- map[Constants.Keys.MatchCast.comments]
    }
    
}

class Comment: Mappable {
    var eventId: Int?
    var eventTypeId: Int?
    var time: String?
    var type: Int?
    var text: String?
    var funfact: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        eventId <- map[Constants.Keys.Comment.eventId]
        eventTypeId <- map[Constants.Keys.Comment.eventTypeId]
        time <- map[Constants.Keys.Comment.time]
        type <- map[Constants.Keys.Comment.type]
        text <- map[Constants.Keys.Comment.text]
        funfact <- map[Constants.Keys.Comment.funfact]
    }
    
}
