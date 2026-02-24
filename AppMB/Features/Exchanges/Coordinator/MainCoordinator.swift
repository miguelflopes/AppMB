//
//  MainCoordinator.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation
import UIKit

@MainActor
protocol MainCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }

    func start()
    func startDetails(_ exchange: ExchangeInfoModel)
    func openError(_ title: String, _ message: String)
}

@MainActor
final class MainCoordinator: MainCoordinatorProtocol {
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        startFlowExchangesViewController()
    }
    
    // MARK: - Flow Exchanges
    
    private func startFlowExchangesViewController() {
        let viewModel = ExchangesViewModel()
        let dataSource = ExchangesDataSource()
        let view = ExchangesView()
        let viewController = ExchangesViewController(viewModel: viewModel,
                                                 dataSource: dataSource,
                                                 contentView: view,
                                                 delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Flow Exchange Details
    
    func startDetails(_ exchange: ExchangeInfoModel) {
        let viewModel = ExchangeDetailViewModel(exchange: exchange)
        let view = ExchangeDetailView()
        let detailViewController = ExchangeDetailViewController(viewModel: viewModel,
                                                            contentView: view,
                                                            delegate: self)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Show Error
    
    func openError(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringHelper.labelOk, style: .default) { _ in
            self.navigationController.popViewController(animated: true)
        })
        navigationController.present(alert, animated: true)
    }
}
