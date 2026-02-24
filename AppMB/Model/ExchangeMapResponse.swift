//
//  ExchangeMapResponse.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

// MARK: - ExchangeMapResponse

struct ExchangeMapResponse: Decodable {
    let data: [ExchangeMapItem]
    let status: Status
}

struct ExchangeMapItem: Codable {
    let id: Int
    let isActive: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
    }
}
