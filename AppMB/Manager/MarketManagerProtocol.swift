//
//  MarketManagerProtocol.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

protocol MarketManagerProtocol {
    // MARK: - Functions
    
    /// Fetches exchanges via /exchange/map then enriches with /exchange/info
    func fetchExchanges(start: Int, limit: Int) async throws -> [ExchangeInfoModel]
    
    /// Fetches assets for a specific exchange ID
    func fetchExchangeAssets(id: Int) async throws -> [ExchangeAssetModel]
}
