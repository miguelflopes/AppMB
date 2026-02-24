//
//  ExchangeInfoResponse.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

// MARK: - ExchangeInfoResponse

struct ExchangeInfoResponse: Decodable {
    let data: [String: ExchangeInfoModel]
    let status: Status
}

struct ExchangeInfoModel: Codable {
    let id: Int
    let name: String
    let slug: String
    let description: String?
    let dateLaunched: String?
    let logo: String?
    let urls: ExchangeInfoUrls?
    var isActive: Int?
    var spotVolumeUSD: Double?
    var makerFee: Double?
    var takerFee: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, logo, urls
        case dateLaunched = "date_launched"
        case isActive = "is_active"
        case spotVolumeUSD = "spot_volume_usd"
        case makerFee = "maker_fee"
        case takerFee = "taker_fee"
    }
}

struct ExchangeInfoUrls: Codable {
    let website: [String]?
    let twitter: [String]?
    let blog: [String]?
    let chat: [String]?
    let fee: [String]?
}
