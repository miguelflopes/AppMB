//
//  ExchangeInfoModelMock.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation
@testable import AppMB

extension ExchangeInfoModel {
    static func fixture() -> [ExchangeInfoModel] {
        return [
            ExchangeInfoModel(
                id: 1,
                name: "Binance",
                slug: "binance",
                description: "Leading global cryptocurrency exchange",
                dateLaunched: "2017-07-14",
                logo: "https://s2.coinmarketcap.com/static/img/exchanges/64x64/1.png",
                urls: ExchangeInfoUrls(
                    website: ["https://binance.com"],
                    twitter: ["https://twitter.com/binance"],
                    blog: nil,
                    chat: nil,
                    fee: ["https://binance.com/fees"]
                ),
                isActive: 1,
                spotVolumeUSD: 15_000_000_000.0
            ),
            ExchangeInfoModel(
                id: 2,
                name: "Coinbase",
                slug: "coinbase",
                description: "US-based cryptocurrency exchange",
                dateLaunched: "2012-06-01",
                logo: "https://s2.coinmarketcap.com/static/img/exchanges/64x64/2.png",
                urls: ExchangeInfoUrls(
                    website: ["https://coinbase.com"],
                    twitter: nil,
                    blog: nil,
                    chat: nil,
                    fee: nil
                ),
                isActive: 1,
                spotVolumeUSD: 5_000_000_000.0
            ),
            ExchangeInfoModel(
                id: 3,
                name: "BitStamp",
                slug: "bitstamp",
                description: "European exchange",
                dateLaunched: "2011-08-01",
                logo: "https://s2.coinmarketcap.com/static/img/exchanges/64x64/3.png",
                urls: nil,
                isActive: 0,
                spotVolumeUSD: 1_000_000_000.0
            )
        ]
    }
}

extension ExchangeAssetModel {
    static func fixture(
        balance: Double? = 1_000,
        cryptoId: Int = 1,
        priceUSD: Double = 50_000,
        symbol: String = "BTC",
        name: String = "Bitcoin"
    ) -> ExchangeAssetModel {
        ExchangeAssetModel(
            balance: balance,
            platform: nil,
            currency: CurrencyDetail(
                cryptoId: cryptoId,
                priceUSD: priceUSD,
                symbol: symbol,
                name: name
            )
        )
    }
}
