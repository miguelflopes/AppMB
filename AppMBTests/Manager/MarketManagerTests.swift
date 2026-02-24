//
//  MarketManagerTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
@testable import AppMB

final class MarketManagerTests: XCTestCase {
    func testFetchExchangesReturnsInfoValues() async throws {
        let network = NetworkMock()
        let sut = MarketManager(network: network)
        
        let mapResponse = ExchangeMapResponse(
            data: [ExchangeMapItem(id: 1, isActive: 1)],
            status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil)
        )
        let exchange = ExchangeInfoModel(
            id: 1,
            name: "Binance",
            slug: "binance",
            description: nil,
            dateLaunched: nil,
            logo: nil,
            urls: nil,
            isActive: 1,
            spotVolumeUSD: 10
        )
        let infoResponse = ExchangeInfoResponse(
            data: ["1": exchange],
            status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil)
        )
        
        network.onExecute = { endpoint in
            guard let marketEndpoint = endpoint as? MarketEndpoint else {
                throw NetworkError.unknownError
            }
            switch marketEndpoint {
            case .map:
                return mapResponse
            case .info:
                return infoResponse
            case .assets:
                return ExchangeAssetResponse(
                    status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil),
                    data: []
                )
            }
        }
        
        let result = try await sut.fetchExchanges(start: 1, limit: 20)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Binance")
    }
    
    func testFetchExchangesWithEmptyMapReturnsEmpty() async throws {
        let network = NetworkMock()
        let sut = MarketManager(network: network)
        
        let mapResponse = ExchangeMapResponse(
            data: [],
            status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil)
        )
        
        network.onExecute = { endpoint in
            guard let marketEndpoint = endpoint as? MarketEndpoint else {
                throw NetworkError.unknownError
            }
            switch marketEndpoint {
            case .map:
                return mapResponse
            case .info:
                XCTFail("Info endpoint should not be called when map is empty")
                return ExchangeInfoResponse(
                    data: [:],
                    status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil)
                )
            case .assets:
                return ExchangeAssetResponse(
                    status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil),
                    data: []
                )
            }
        }
        
        let result = try await sut.fetchExchanges(start: 1, limit: 20)
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFetchExchangeAssetsReturnsAssets() async throws {
        let network = NetworkMock()
        let sut = MarketManager(network: network)
        
        let assets = [
            ExchangeAssetModel(
                balance: 100,
                platform: nil,
                currency: CurrencyDetail(cryptoId: 1, priceUSD: 1.0, symbol: "AAA", name: "Alpha")
            )
        ]
        
        network.onExecute = { endpoint in
            guard let marketEndpoint = endpoint as? MarketEndpoint else {
                throw NetworkError.unknownError
            }
            switch marketEndpoint {
            case .assets:
                return ExchangeAssetResponse(
                    status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil),
                    data: assets
                )
            case .map:
                return ExchangeMapResponse(
                    data: [],
                    status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil)
                )
            case .info:
                return ExchangeInfoResponse(
                    data: [:],
                    status: Status(timestamp: nil, errorCode: nil, errorMessage: nil, elapsed: nil, creditCount: nil)
                )
            }
        }
        
        let result = try await sut.fetchExchangeAssets(id: 99)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.currency.name, "Alpha")
    }
}
