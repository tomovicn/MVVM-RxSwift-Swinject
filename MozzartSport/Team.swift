//
//  Team.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Team: Object, Mappable {
    dynamic var id = 0
    dynamic var name: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map[Constants.Keys.Team.id]
        name <- map[Constants.Keys.Team.name]
    }
    
}
