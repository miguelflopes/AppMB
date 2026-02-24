//
//  ExchangeAssetResponse.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

struct ExchangeAssetResponse: Decodable {
    let status: Status
    let data: [ExchangeAssetModel]
}

struct ExchangeAssetModel: Codable {
    let balance: Double?
    let platform: PlatformInfo?
    let currency: CurrencyDetail
    
    enum CodingKeys: String, CodingKey {
        case balance
        case platform
        case currency
    }
}

struct PlatformInfo: Codable {
    let cryptoId: Int
    let symbol: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case cryptoId = "crypto_id"
        case symbol
        case name
    }
}

struct CurrencyDetail: Codable {
    let cryptoId: Int
    let priceUSD: Double
    let symbol: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case cryptoId = "crypto_id"
        case priceUSD = "price_usd"
        case symbol
        case name
    }
}
