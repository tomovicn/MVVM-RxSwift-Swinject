//
//  Constants.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/24/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation

struct Constants {
    
    struct API {
        
        struct Endpoints {
            
            static let baseUrl = "http://ws.mozzartsport.com"
            
            static let scores = "/index.php/livescores.json?sport_id=1"
            static let matchcast = "/matchcasts.json?match_id="
            
            static let image = "http://static.mozzartsport.com/images/flags/26x17/"
        }
        
        struct Parameters {
            static let type = "type"
            static let fromTime = "from_time"
            static let untilTime = "until_time"
            static let matchId = "match_id"
        }
        
        struct Headers {
            
        }
    }
    
    struct Keys {
        struct Match {
            static let id = "match_id"
            static let categoryId = "category_id"
            static let tournamentId = "tournament_id"
            static let homeTeam = "home_team"
            static let guestTeam = "guest_team"
            static let currentTime = "match_current_time"
            static let tournamentName = "tournament_name"
            static let categoryName = "category_name"
            static let started = "started"
            static let periodStarted = "period_started"
            static let matchTime = "match_time"
            static let status = "status"
            static let statusCode = "status_code"
            static let score = "score"
            static let goals = "goals"
            static let cards = "cards"
        }
        
        struct Team {
            static let id = "team_id"
            static let name = "name"
        }
        
        struct Goal {
            static let player = "player"
            static let time = "time"
            static let team = "team"
            static let score = "score"
            static let homeTeam = "home_team"
            static let guestTeam = "guest_team"
            static let byTime = "by_time"
        }
        
        struct Score {
            static let current = "current"
            static let halfTime = "half_time"
            static let normalTime = "normal_time"
            static let homeTeam = "home_team"
            static let guestTeam = "guest_team"
        }
        
        struct Cards {
            static let cards = "cards"
            static let yellow = "Yellow"
            static let red = "Red"
            static let homeTeam = "home_team"
            static let guestTeam = "guest_team"
            static let player = "player"
            static let time = "time"
        }
        
        struct MatchCast {
            static let comments = "comments"
        }
        
        struct Comment {
            static let eventId = "event_id"
            static let eventTypeId = "event_type_id"
            static let time = "time"
            static let type = "type"
            static let text = "text"
            static let funfact = "funfact"
        }
        
    }
    
    struct Segue {
        static let showMatchCast = "showMatchCast"
    }
    
    struct Notifications {
        static let saveData = "saveData"
    }
}










