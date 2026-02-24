//
//  ExchangeDetailViewController.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

@MainActor
final class ExchangeDetailViewController: UIViewController {

    // MARK: - Private Properties

    private let viewModel: ExchangeDetailViewModel
    private var detailView: ExchangeDetailView
    private weak var delegate: MainCoordinatorProtocol?

    // MARK: - Initializer

    init(viewModel: ExchangeDetailViewModel,
         contentView: ExchangeDetailView,
         delegate: MainCoordinatorProtocol?) {
        self.viewModel = viewModel
        self.detailView = contentView
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        Task { [weak self] in
            guard let self else { return }
            await self.viewModel.fetchAssets()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private Methods

    private func setupView() {
        view = detailView
        title = StringHelper.titleExchangeDetails
        detailView.setupView(exchange: viewModel.exchange)
        detailView.setupAssetsDataSource(self)
        detailView.onOpenWebsite = { url in
            UIApplication.shared.open(url)
        }
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.titleTextAttributes = [
            .foregroundColor: AppColors.textPrimary,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColors.textPrimary
    }
}

// MARK: - ExchangeDetailViewModelDelegate

extension ExchangeDetailViewController: ExchangeDetailViewModelDelegate {
    func onAssetsFetchSuccess() {
        detailView.updateAssets(count: viewModel.assets.count)
    }

    func onAssetsFetchError(_ errorTitle: String, _ errorMessage: String) {
        // Show alert or toast
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringHelper.labelOk, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate

extension ExchangeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath) as? AssetTableViewCell else {
            return UITableViewCell()
        }
        let asset = viewModel.assets[indexPath.row]
        cell.setup(with: asset)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
