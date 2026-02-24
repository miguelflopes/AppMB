//
//  ExchangesViewModelDelegate.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

protocol ExchangesViewModelDelegate: AnyObject {
    func onExchangesFetchSuccess(_ exchanges: [ExchangeInfoModel]?)
    func onExchangesFetchError(_ errorTitle: String, _ errorMessage: String)
    func loading(isLoading: Bool)
    func loadingMore(isLoading: Bool)
    func onTotalVolumeUpdate(_ totalVolume: Double)
}
