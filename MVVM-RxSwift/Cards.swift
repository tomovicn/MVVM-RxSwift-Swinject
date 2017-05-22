//
//  Cards.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 3/25/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

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
    let yellow = List<Card>()
    let red = List<Card>()
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        var yellowCard: [Card]?
        yellowCard <- map[Constants.Keys.Cards.yellow]
        if let yellowCard = yellowCard {
            for card in yellowCard {
                yellow.append(card)
            }
        }
        var redCard: [Card]?
        redCard <- map[Constants.Keys.Cards.red]
        if let redCard = redCard {
            for card in redCard {
                red.append(card)
            }
        }
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
