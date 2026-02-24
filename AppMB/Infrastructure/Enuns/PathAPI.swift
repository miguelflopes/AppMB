//
//  PathAPI.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

protocol PathAPIProtocol {
    var exchangeMap: String { get }
    var exchangeInfo: String { get }
    var exchangeAssets: String { get }
    var apiKey: String { get }
}

// MARK: - PathAPI

final class PathAPI: PathAPIProtocol {
    var exchangeMap = ApplicationConstants.PathAPI().exchangeMap
    var exchangeInfo = ApplicationConstants.PathAPI().exchangeInfo
    var exchangeAssets = ApplicationConstants.PathAPI().exchangeAssets
    var apiKey = ApplicationConstants.PathAPI.apiKey
}
