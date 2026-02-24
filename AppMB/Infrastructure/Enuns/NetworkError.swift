//
//  NetworkError.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

// MARK: - NetworkError

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case badRequest
    case serverError
    case unknownError
}
