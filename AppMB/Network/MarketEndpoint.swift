//
//  MarketEndpoint.swift
//  AppMB
//
//  Created by Miguel Lopes on 20/02/26.
//

import Foundation

enum MarketEndpoint: APIEndpoint {
    case map(start: Int, limit: Int)
    case info(ids: String)
    case assets(id: Int)
    
    var baseURL: String {
        return "https://pro-api.coinmarketcap.com/v1"
    }
    
    var path: String {
        switch self {
        case .map:
            return "/exchange/map"
        case .info:
            return "/exchange/info"
        case .assets:
            return "/exchange/assets"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return [
            "X-CMC_PRO_API_KEY": ApplicationConstants.PathAPI.apiKey,
            "Accept": "application/json"
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "CMC_PRO_API_KEY", value: ApplicationConstants.PathAPI.apiKey)
        ]
        
        switch self {
        case .map(let start, let limit):
            items.append(URLQueryItem(name: "start", value: "\(start)"))
            items.append(URLQueryItem(name: "limit", value: "\(limit)"))
        case .info(let ids):
            items.append(URLQueryItem(name: "id", value: ids))
        case .assets(let id):
            items.append(URLQueryItem(name: "id", value: "\(id)"))
        }
        return items
    }
}
