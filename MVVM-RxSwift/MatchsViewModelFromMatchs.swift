//
//  MatchsViewModelFromMatchs.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 5/12/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum FilterType: Int {
    case all = 0
    case favorites = 1
    case live = 2
    case finished = 3
    case next = 4
}

class MatchsViewModelFromMatchs: MatchsViewModel {
    
    private var allMatchs: [Match] = [Match]()
    private var dataSource: [Match] = [Match]()
    private var favoriteMatchs: [Match]
    
    let apiManager: APIManager
    var isLoading: Variable<Bool> = Variable(false)
    var errorMessage: Variable<String?> = Variable(nil)
    var date: Variable<Date>  = Variable(Date())
    var timeFrom: Variable<Date> = Variable(Date.defaultTimeFrom())
    var timeUntil: Variable<Date> = Variable(Date.defaultTimeUntil())
    
    var filterType: FilterType = .all {
        didSet {
            switch filterType {
            case .all:
                dataSource = allMatchs
            case .favorites:
                dataSource = favoriteMatchs
            case .live:
                getLivescores()
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
    let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    
    private enum MatchsDataEvent {
        case loading
        case matchData([Match])
        case error(Error)
    }
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
        self.favoriteMatchs = DBHelper().getFavouriteMatchs()
        //handle saving to Database when app goes to background
        NotificationCenter.default.addObserver(self, selector: #selector(saveFavorites), name: NSNotification.Name.init(rawValue: Constants.Notifications.saveData), object: nil)
    }
    
    // MARK: Fetch Data
    func startFetch(refreshDriver: Driver<Void>) {
        
        let scoresEventDriver = refreshDriver
            .startWith(())
            .flatMapLatest { _ -> Driver<MatchsDataEvent> in
                return self.apiManager.getScores(fromTime: self.timeFromInterval(), untilTime: self.timeUntilInterval())
                            .map { return  MatchsDataEvent.matchData($0) }
                            .asDriver(onErrorRecover: { (error)  in
                                return Driver.just(MatchsDataEvent.error(error))
                            })
                            .startWith(.loading)
        }
        
        scoresEventDriver.drive(onNext: { (event) in
                switch event {
                case .loading: self.isLoading.value = true
                case .matchData(let matchs):
                    self.allMatchs = matchs
                    self.dataSource = matchs
                    self.isLoading.value = false
                case .error(let error):
                    self.isLoading.value = false
                    self.errorMessage.value = error.localizedDescription
                }
            }).disposed(by: disposeBag)
    }
    
    func getLivescores() {
        isLoading.value = true
        
        apiManager.getLivescores(succes: { (matchs) in
            self.dataSource = matchs
            self.isLoading.value = false
        }) { (error) in
            self.isLoading.value = false
            self.errorMessage.value = error
        }
    }
    
    // MARK: Favorites
    
    @objc func saveFavorites() {
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
    
    func matchIDFor(section: Int) -> String {
        return String(dataSource[section].id)
    }
    
    // MARK: Data/Time management
    func timeFromInterval() -> TimeInterval {
        var components = gregorian.components([.year, .month, .day, .hour, .minute], from: date.value)
        let timeFromComponents = gregorian.components([.year, .month, .day, .hour, .minute], from: timeFrom.value)
        
        components.hour = timeFromComponents.hour
        components.minute = timeFromComponents.minute
        
        return gregorian.date(from: components)!.timeIntervalSince1970
    }
    
    func timeUntilInterval() -> TimeInterval {
        var components = gregorian.components([.year, .month, .day, .hour, .minute], from: date.value)
        let timeUntilComponents = gregorian.components([.year, .month, .day, .hour, .minute], from: timeUntil.value)
        
        components.hour = timeUntilComponents.hour
        components.minute = timeUntilComponents.minute
        
        return gregorian.date(from: components)!.timeIntervalSince1970
    }
    
}

