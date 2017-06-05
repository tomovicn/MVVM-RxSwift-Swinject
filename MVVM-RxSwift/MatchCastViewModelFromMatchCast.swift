//
//  MatchCastViewModelFromMatchCast.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 6/5/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MatchCastViewModelFromMatchCast: MatchCastViewModel {
    
    private var matchCast = MatchCast() {
        didSet {
            if let comms = matchCast.comments {
                comments.removeAll()
                for index in 0...(comms.count - 1) {
                    comments.append(comms[String(index)]!)
                }
            }
        }
    }
    private var comments = [Comment]()
    
    let apiManager: APIManager
    var isLoading: Variable<Bool> = Variable(false)
    var errorMessage: Variable<String?> = Variable(nil)
    var homeTeam: Variable<String> = Variable("")
    var guestTeam: Variable<String> = Variable("")
    var result: Variable<String> = Variable("")
    
    private enum MatchCastDataEvent {
        case loading
        case matchCastData(MatchCast)
        case error(Error)
    }
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    // MARK: Get Data
    func getData(refreshDriver: Driver<Void>, matchID: String) {
        
        let matchCastEventDriver = refreshDriver
            .startWith(())
            .flatMapLatest { _ -> Driver<MatchCastDataEvent> in
                return self.apiManager.getMatchCast(matchId: matchID)
                    .map {  MatchCastDataEvent.matchCastData($0) }
                    .asDriver(onErrorRecover: { (error)  in
                        return Driver.just(MatchCastDataEvent.error(error))
                    })
                    .startWith(.loading)
        }
        
        matchCastEventDriver.drive(onNext: { event in
            switch event {
            case .loading: self.isLoading.value = true
            case .matchCastData(let matchCast):
                self.matchCast = matchCast
                self.homeTeam.value = matchCast.homeTeam?.name ?? ""
                self.guestTeam.value = matchCast.guestTeam?.name ?? ""
                var result = ""
                if let homeScore = matchCast.score?.current?.homeTeam {
                    result = String(homeScore) + " : "
                }
                if let guestScore = matchCast.score?.current?.guestTeam {
                    result = result + String(guestScore)
                }
                self.result.value = result
                self.isLoading.value = false
            case .error(let error):
                self.isLoading.value = false
                self.errorMessage.value = error.localizedDescription
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: MatchCastViewModel
    
    func numberOfSections() -> Int {
        return 1
    }
    func numberOfRowsFor(section: Int) -> Int {
        return comments.count
    }
    func viewModelFor(section: Int, row: Int) -> MatchCastCellViewModel {
        let viewCellModel = MatchCastCellViewModelFromComment(withComment: comments[row])
        return viewCellModel
    }
    
    
}
