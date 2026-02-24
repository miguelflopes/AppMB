//
//  ExchangesViewController.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

@MainActor
final class ExchangesViewController: UIViewController {

    // MARK: - Private Properties

    private var viewModel: ExchangesViewModelProtocol
    private let dataSource: ExchangesDataSourceProtocol
    private var contentView: ExchangesViewProtocol
    private weak var delegate: MainCoordinatorProtocol?

    // MARK: - Initializer

    init(viewModel: ExchangesViewModelProtocol,
         dataSource: ExchangesDataSourceProtocol,
         contentView: ExchangesViewProtocol,
         delegate: MainCoordinatorProtocol?) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        self.contentView = contentView
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        Task { [weak self] in
            guard let self else { return }
            await self.viewModel.fetchExchanges()
        }
        bindActions()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private Methods

    private func setupView() {
        view = contentView
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func bindActions() {
        contentView.onFetchExchanges = { [weak self] in
            Task { [weak self] in
                guard let self else { return }
                await self.viewModel.fetchExchanges()
            }
        }

        dataSource.loadMore = { [weak self] in
            Task { [weak self] in
                guard let self else { return }
                await self.viewModel.loadMoreExchanges()
            }
        }

        contentView.onSearch = { [weak self] textField in
            Task { [weak self] in
                guard let self else { return }
                self.viewModel.search(search: textField)
            }
        }

        contentView.openDetails = { [weak self] exchange in
            self?.delegate?.startDetails(exchange)
        }
    }
}

// MARK: - ExchangesViewModelDelegate

extension ExchangesViewController: ExchangesViewModelDelegate {
    func onExchangesFetchSuccess(_ exchanges: [ExchangeInfoModel]?) {
        dataSource.exchanges = exchanges
        contentView.setupTableView(dataSource: dataSource)
    }

    func onExchangesFetchError(_ errorTitle: String, _ errorMessage: String) {
        delegate?.openError(errorTitle, errorMessage)
    }
    
    func loading(isLoading: Bool) {
        contentView.loadingView(isLoading: isLoading)
    }

    func loadingMore(isLoading: Bool) {
        contentView.loadingMore(isLoading: isLoading)
    }

    func onTotalVolumeUpdate(_ totalVolume: Double) {
        contentView.updateTotalVolume(totalVolume)
    }
}
