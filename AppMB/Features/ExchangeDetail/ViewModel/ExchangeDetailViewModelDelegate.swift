//
//  ExchangeDetailViewModelDelegate.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

protocol ExchangeDetailViewModelDelegate: AnyObject {
    func onAssetsFetchSuccess()
    func onAssetsFetchError(_ errorTitle: String, _ errorMessage: String)
}
