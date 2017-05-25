//
//  MatchViewModel.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 5/11/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MatchsViewModel {
    var isLoading: Variable<Bool> { get }
    var errorMessage: Variable<String?> { get }
    var date: Variable<Date> { get }
    var timeFrom: Variable<Date> { get }
    var timeUntil: Variable<Date> { get }
    var filterType: FilterType { get set }
    
    func startFetch(refreshDriver: Driver<Void>)
    
    //TableView
    func numberOfSections() -> Int
    func numberOfRowsFor(section: Int) -> Int
    func viewModelFor(section: Int, row: Int) -> MatchCellViewModel
    func matchIDFor(section: Int) -> String
    
    //Favorites
    func removeFromFavorites(viewCellModel: MatchCellViewModel)
    func addToFavorites(viewCellModel: MatchCellViewModel)
}
