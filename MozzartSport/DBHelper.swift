//
//  DBHelper.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/26/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import RealmSwift

struct DBHelper {
    let realm: Realm = try! Realm()
    
    func getFavouriteMatchs() -> [Match] {
        return Array(realm.objects(Match.self))
    }
    
    func saveFavourites(matchs: [Match]) {
        let previoslySaved = getFavouriteMatchs()
        let matchsToDelete = previoslySaved.filter { (match) -> Bool in
            return !matchs.contains(match)
        }
        let matchsToAdd = matchs.filter { (match) -> Bool in
            return !previoslySaved.contains(match)
        }
        do {
            try realm.write {
                realm.delete(matchsToDelete)
                realm.add(matchsToAdd, update: true)
            }
        } catch let error {
            print(error)
        }
    }
    
}
