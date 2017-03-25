//
//  Cards.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import ObjectMapper

class CardsGroup: Mappable {
    var homeTeam: Cards?
    var guestTeam: Cards?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        homeTeam <- map[Constants.Keys.Cards.homeTeam]
        guestTeam <- map[Constants.Keys.Cards.guestTeam]
    }
    
}

class Cards: Mappable {
    var yellow: [Card]?
    var red: [Card]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        yellow <- map[Constants.Keys.Cards.yellow]
        red <- map[Constants.Keys.Cards.red]
    }
    
}

class Card: Mappable {
    var time: Int?
    var player: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        player <- map[Constants.Keys.Cards.player]
        time <- map[Constants.Keys.Cards.time]
    }
    
}
