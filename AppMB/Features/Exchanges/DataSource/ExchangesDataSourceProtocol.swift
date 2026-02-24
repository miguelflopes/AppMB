//
//  ExchangesDataSourceProtocol.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

protocol ExchangesDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    var exchanges: [ExchangeInfoModel]? { get set }
    var isLoadingMore: Bool { get set }
    var openDetails: ((ExchangeInfoModel) -> ())? { get set }
    var loadMore: (() -> Void)? { get set }
}
