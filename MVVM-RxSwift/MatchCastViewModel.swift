//
//  MatchCastViewModel.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 6/5/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MatchCastViewModel {
    var isLoading: Variable<Bool> { get }
    var errorMessage: Variable<String?> { get }
    var homeTeam: Variable<String> { get }
    var guestTeam: Variable<String> { get }
    var result: Variable<String> { get }
    
    func getData(refreshDriver: Driver<Void>, matchID: String)
    
    //TableView
    func numberOfSections() -> Int
    func numberOfRowsFor(section: Int) -> Int
    func viewModelFor(section: Int, row: Int) -> MatchCastCellViewModel
}
