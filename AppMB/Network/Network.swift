//
//  Network.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

protocol NetworkProtocol {
    func execute<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class Network: NetworkProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func execute<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200..<300:
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw error
            }
        case 400..<500:
            throw NetworkError.badRequest
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknownError
        }
    }
}
