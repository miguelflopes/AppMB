//
//  MarketManagerMock.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation
@testable import AppMB

final class MarketManagerMock: MarketManagerProtocol {
    
    var fetchExchangesResult: Result<[ExchangeInfoModel], Error>!
    var fetchExchangeAssetsResult: Result<[ExchangeAssetModel], Error>!
    
    private(set) var fetchExchangesCount = 0
    private(set) var lastStart: Int?
    private(set) var lastLimit: Int?
    
    private(set) var fetchAssetsCount = 0
    private(set) var lastAssetId: Int?

    func fetchExchanges(start: Int, limit: Int) async throws -> [ExchangeInfoModel] {
        fetchExchangesCount += 1
        lastStart = start
        lastLimit = limit
        
        switch fetchExchangesResult {
        case .success(let model): return model
        case .failure(let error): throw error
        case .none: return []
        }
    }
    
    func fetchExchangeAssets(id: Int) async throws -> [ExchangeAssetModel] {
        fetchAssetsCount += 1
        lastAssetId = id
        
        switch fetchExchangeAssetsResult {
        case .success(let model): return model
        case .failure(let error): throw error
        case .none: return []
        }
    }
}
