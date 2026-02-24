//
//  ExchangeDetailViewModelProtocol.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

protocol ExchangeDetailViewModelProtocol {
    
    // MARK: - Properties
    
    var exchange: ExchangeInfoModel { get }
    var assets: [ExchangeAssetModel] { get }
    var delegate: ExchangeDetailViewModelDelegate? { get set }
    
    // MARK: - Methods
    
    @MainActor func fetchAssets() async
}
