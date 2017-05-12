//
//  MatchsViewModelFromMatchs.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 5/12/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation

enum FilterType: Int {
    case all = 0
    case favorites = 1
    case live = 2
    case finished = 3
    case next = 4
}

class MatchsViewModelFromMatchs: MatchsViewModel {
    
    private let allMatchs: [Match]
    private var dataSource: [Match]
    private var favoriteMatchs: [Match]
    var liveMatchs: [Match] = [Match]()
    var filterType: FilterType {
        didSet {
            switch filterType {
            case .all:
                dataSource = allMatchs
            case .favorites:
                dataSource = favoriteMatchs
            case .live:
                dataSource = liveMatchs
            case .finished:
                dataSource = allMatchs.filter({ (match) -> Bool in
                    return match.statusCode == 100
                })
            case .next:
                dataSource = allMatchs.filter({ (match) -> Bool in
                    return match.statusCode == 0
                })
            }
        }
    }
    
    // MARK: Init
    
    init(withMatchs matchs: [Match]) {
        self.allMatchs = matchs
        self.dataSource = matchs
        self.favoriteMatchs = DBHelper().getFavouriteMatchs()
        self.filterType = .all
    }
    
    // MARK: Favorites
    
    func saveFavorites() {
        DBHelper().saveFavourites(matchs: favoriteMatchs)
    }
    
    func removeFromFavorites(viewCellModel: MatchCellViewModel) {
        let viewCellModelFromMatch = viewCellModel as! MatchCellViewModelFromMatch
        viewCellModelFromMatch.isFavorite = false
        favoriteMatchs.remove(at: favoriteMatchs.index(of: viewCellModelFromMatch.match)!)
    }
    
    func addToFavorites(viewCellModel: MatchCellViewModel) {
        let viewCellModelFromMatch = viewCellModel as! MatchCellViewModelFromMatch
        viewCellModelFromMatch.isFavorite = true
        favoriteMatchs.append(viewCellModelFromMatch.match)
    }
    
    // MARK: MatchsViewModel
    
    func numberOfSections() -> Int {
        return dataSource.count
    }
    func numberOfRowsFor(section: Int) -> Int {
        return 1
    }
    func viewModelFor(section: Int, row: Int) -> MatchCellViewModel {
        let match = dataSource[section]
        let viewCellModel = MatchCellViewModelFromMatch(withMatch: match)
        viewCellModel.isFavorite = favoriteMatchs.contains(match)
        return viewCellModel
    }
    
}
