//
//  MatchCast.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import ObjectMapper

class MatchCast: Match {
    
    required convenience init?(map: Map){
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
    
}
