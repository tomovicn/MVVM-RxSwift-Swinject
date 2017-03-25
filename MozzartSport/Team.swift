//
//  Team.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import ObjectMapper

class Team: Mappable {
    var id: Int?
    var name: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map[Constants.Keys.Team.id]
        name <- map[Constants.Keys.Team.name]
    }
    
}
