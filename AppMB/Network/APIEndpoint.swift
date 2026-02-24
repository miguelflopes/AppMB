//
//  APIEndpoint.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var urlRequest: URLRequest? { get }
}

extension APIEndpoint {
    var urlRequest: URLRequest? {
        guard var components = URLComponents(string: baseURL + path) else { return nil }
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        return request
    }
}
