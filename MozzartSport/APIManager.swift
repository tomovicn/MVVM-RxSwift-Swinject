//
//  APIManager.swift
//  MozzartSport
//
//  Created by Nikola Tomovic on 3/24/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift

public final class APIManager
{
    public init() { }
    
    private let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    func getScores(fromTime: TimeInterval, untilTime: TimeInterval) -> Observable<[Match]> {
        let observable = Observable<[Match]>.create { [unowned self] observer in
            self.manager.request(LivescoresRouter.scores(fromTime: fromTime, untilTime: untilTime)).validate().responseArray(keyPath: "livescores") { (response: DataResponse<[Match]>) in
                
                switch response.result {
                case .success(let matchs):
                    observer.onNext(matchs)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        
        return observable.shareReplay(1)
    }
    
    func getLivescores(succes: @escaping (_ scores : [Match]) -> Void, failure : @escaping ((String) -> Void) ) {
        
        manager.request(LivescoresRouter.liveScores).validate().responseArray(keyPath: "livescores") { (response: DataResponse<[Match]>) in
            
            switch response.result {
            case .success(let matchs):
                succes(matchs)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
        
    }
    
    func getMatchCast(matchId: String, succes: @escaping (_ matchcast : MatchCast) -> Void, failure : @escaping ((String) -> Void) ) {
        
//        manager.request(LivescoresRouter.matchcast(matchId: matchId)).validate().responseObject( keyPath: "matchcast") { (response: DataResponse<MatchCast>) in
//            switch response.result {
//            case .success(let matchcast):
//                succes(matchcast)
//            case .failure(let error):
//                failure(error.localizedDescription)
//            }
//        }
        
        let urlString = Constants.API.Endpoints.baseUrl + Constants.API.Endpoints.matchcast + matchId
        manager.request(urlString).validate().responseObject( keyPath: "matchcast") { (response: DataResponse<MatchCast>) in
            switch response.result {
            case .success(let matchcast):
                succes(matchcast)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
        
    }
    
}
