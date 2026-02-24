//
//  ExchangeDetailViewModel.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

final class ExchangeDetailViewModel: ExchangeDetailViewModelProtocol {
    
    // MARK: - Public Properties
    
    let exchange: ExchangeInfoModel
    private(set) var assets: [ExchangeAssetModel] = []
    weak var delegate: ExchangeDetailViewModelDelegate?
    
    // MARK: - Private Properties
    
    private let manager: MarketManagerProtocol
    
    // MARK: - Initializer
    
    init(exchange: ExchangeInfoModel, manager: MarketManagerProtocol = MarketManager()) {
        self.exchange = exchange
        self.manager = manager
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func fetchAssets() async {
        do {
            let fetchedAssets = try await manager.fetchExchangeAssets(id: exchange.id)
            assets = fetchedAssets
            delegate?.onAssetsFetchSuccess()
        } catch {
            delegate?.onAssetsFetchError(StringHelper.errorTitleSorry, StringHelper.errorLoadMessage)
        }
    }
}
