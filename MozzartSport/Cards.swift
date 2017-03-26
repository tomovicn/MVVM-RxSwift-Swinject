//
//  Cards.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class CardsGroup: Object, Mappable {
    dynamic var homeTeam: Cards?
    dynamic var guestTeam: Cards?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        homeTeam <- map[Constants.Keys.Cards.homeTeam]
        guestTeam <- map[Constants.Keys.Cards.guestTeam]
    }
    
}

class Cards: Object, Mappable {
    var yellow = List<Card>()
    var red = List<Card>()
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        yellow <- map[Constants.Keys.Cards.yellow]
        red <- map[Constants.Keys.Cards.red]
    }
    
}

class Card: Object, Mappable {
    dynamic var time = 0
    dynamic var player: String?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        player <- map[Constants.Keys.Cards.player]
        time <- map[Constants.Keys.Cards.time]
    }
    
}
