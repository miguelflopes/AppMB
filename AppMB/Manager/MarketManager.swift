//
//  MarketManager.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

final class MarketManager: MarketManagerProtocol {
    private let network: NetworkProtocol

    init(network: NetworkProtocol = Network()) {
        self.network = network
    }

    func fetchExchanges(start: Int, limit: Int) async throws -> [ExchangeInfoModel] {
        let mapResponse: ExchangeMapResponse = try await network.execute(MarketEndpoint.map(start: start, limit: limit))
        let items = mapResponse.data
        
        guard !items.isEmpty else { return [] }
        let ids = items.map { String($0.id) }.joined(separator: ",")
        let infoResponse: ExchangeInfoResponse = try await network.execute(MarketEndpoint.info(ids: ids))
        return Array(infoResponse.data.values)
    }

    func fetchExchangeAssets(id: Int) async throws -> [ExchangeAssetModel] {
        let response: ExchangeAssetResponse = try await network.execute(MarketEndpoint.assets(id: id))
        return response.data
    }
}
