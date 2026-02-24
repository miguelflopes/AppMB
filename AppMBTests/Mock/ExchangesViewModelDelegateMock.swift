//
//  ExchangesViewModelDelegateMock.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation
@testable import AppMB

final class ExchangesViewModelDelegateMock: ExchangesViewModelDelegate {
    var exchanges: [ExchangeInfoModel]?
    var errorTitle: String?
    var errorMessage: String?
    var isLoading: Bool = false
    
    var onSuccessCalled: (() -> Void)?
    var onErrorCalled: (() -> Void)?

    func onExchangesFetchSuccess(_ exchanges: [ExchangeInfoModel]?) {
        self.exchanges = exchanges
        onSuccessCalled?()
    }

    func onExchangesFetchError(_ errorTitle: String, _ errorMessage: String) {
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
        onErrorCalled?()
    }
    
    func loading(isLoading: Bool) {
        self.isLoading = isLoading
    }

    func loadingMore(isLoading: Bool) {
        self.isLoading = isLoading
    }

    var lastTotalVolume: Double?
    func onTotalVolumeUpdate(_ totalVolume: Double) {
        self.lastTotalVolume = totalVolume
    }
}
