//
//  ExchangeDetailViewModelDelegateMock.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation
@testable import AppMB

final class ExchangeDetailViewModelDelegateMock: ExchangeDetailViewModelDelegate {
    var isLoadingAssets: Bool = false
    var assetsFetched: Bool = false
    var errorTitle: String?
    var errorMessage: String?
    
    var onSuccessCalled: (() -> Void)?
    var onErrorCalled: (() -> Void)?

    func onAssetsFetchSuccess() {
        assetsFetched = true
        onSuccessCalled?()
    }

    func onAssetsFetchError(_ errorTitle: String, _ errorMessage: String) {
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
        onErrorCalled?()
    }

    func loadingAssets(isLoading: Bool) {
        self.isLoadingAssets = isLoading
    }
}
