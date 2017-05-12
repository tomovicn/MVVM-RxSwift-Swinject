//
//  MatchViewModel.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 5/11/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation

protocol MatchsViewModel {
    var liveMatchs: [Match] { get set }
    var filterType: FilterType { get set }
    
    func numberOfSections() -> Int
    func numberOfRowsFor(section: Int) -> Int
    func viewModelFor(section: Int, row: Int) -> MatchCellViewModel
    func saveFavorites()
    func removeFromFavorites(viewCellModel: MatchCellViewModel)
    func addToFavorites(viewCellModel: MatchCellViewModel)
}

protocol MatchCellViewModel {
    var matchTime: String { get }
    var homeTeam: String { get }
    var guestTeam: String { get }
    var homeYellowCards: String { get }
    var guestYellowCards: String { get }
    var homeRedCards: String { get }
    var guestRedCards: String { get }
    var homeScoreFirstHalf: String { get }
    var guestScoreFirstHalf: String { get }
    var homeScore: String { get }
    var guestScore: String { get }
    var homeShooters: String { get }
    var guestShooters: String { get }
    var isFavorite: Bool { get set }
}
