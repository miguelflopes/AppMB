//
//  ExchangesDataSource.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

final class ExchangesDataSource: NSObject, ExchangesDataSourceProtocol {
    var exchanges: [ExchangeInfoModel]? = []
    var isLoadingMore: Bool = false
    var openDetails: ((ExchangeInfoModel) -> ())?
    var loadMore: (() -> Void)?

    override init() { }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = exchanges?.count ?? 0
        return isLoadingMore ? count + 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = exchanges?.count ?? 0
        
        if isLoadingMore && indexPath.row == count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SkeletonExchangeCell.self), for: indexPath) as? SkeletonExchangeCell else {
                return UITableViewCell()
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeTableViewCell.self.className, for: indexPath) as? ExchangeTableViewCell else {
            return UITableViewCell()
        }
        guard let exchange = exchanges?[indexPath.row] else { return cell }
        
        let cellViewModel = ExchangeCellViewModel(exchange: exchange, rank: indexPath.row + 1)
        cell.setupView(viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = exchanges?.count ?? 0
        guard count > 0 else { return }
        
        if indexPath.row == count - 1 {
            loadMore?()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = exchanges?.count ?? 0
        guard indexPath.row < count, let exchange = exchanges?[indexPath.row] else { return }
        openDetails?(exchange)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
