//
//  LivescoresRouter.swift
//  MVVM-RxSwift
//
//  Created by Nikola Tomovic on 3/24/17.
//  Copyright © 2017 Nikola Tomovic. All rights reserved.
//

import Alamofire

enum LivescoresRouter: URLRequestConvertible {
    
    case liveScores
    case scores(fromTime: TimeInterval, untilTime: TimeInterval)
    case matchcast(matchId: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var path: String {
        
        switch self {
        case .scores(let fromTime, let untilTime):
            return Constants.API.Endpoints.scores + "&from_time=" + String(fromTime) + "&until_time=" + String(untilTime)
        case .liveScores:
            return Constants.API.Endpoints.scores + "&type=LIVE"
        case .matchcast(let matchId):
            return Constants.API.Endpoints.matchcast + matchId
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .liveScores:
            return [Constants.API.Parameters.type : "LIVE"]
        case .scores(let fromTime, let untilTime):
            return [Constants.API.Parameters.fromTime : fromTime, Constants.API.Parameters.untilTime : untilTime]
        case .matchcast:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.API.Endpoints.baseUrl.asURL()
        
        var urlRequest: URLRequest
        urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
//        switch self {
//        case .liveScores, .scores:
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//        default:
//            break
//        }
        
        return urlRequest
    }
}
