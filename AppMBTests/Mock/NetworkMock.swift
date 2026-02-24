//
//  NetworkMock.swift
//  AppMB
//
//  Created by Miguel Lopes on 24/02/26.
//

@testable import AppMB

final class NetworkMock: NetworkProtocol {
    var onExecute: ((APIEndpoint) throws -> Any)?
    
    func execute<T>(_ endpoint: APIEndpoint) async throws -> T where T : Decodable {
        if let value = try onExecute?(endpoint) as? T {
            return value
        }
        throw NetworkError.unknownError
    }
}
