//
//  ExchangesViewProtocol.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

protocol ExchangesViewProtocol where Self: UIView {
    var onFetchExchanges: (() -> Void)? { get set }
    var onSearch: ((String) -> Void)? { get set }
    var openDetails: ((ExchangeInfoModel) -> ())? { get set }

    func setupTableView(dataSource: ExchangesDataSourceProtocol)
    func loadingView(isLoading: Bool)
    func loadingMore(isLoading: Bool)
    func updateTotalVolume(_ totalVolume: Double)
}
