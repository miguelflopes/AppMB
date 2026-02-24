//
//  ExchangesView.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

@MainActor
final class ExchangesView: UIView {
    // MARK: - Private Properties

    private var searchDelay: Timer?
    private let delayStartSearch: TimeInterval = 0.8
    private var isShowingSkeleton = true
    private let keyboardDismissTap = KeyboardDismissTapComponent()

    // MARK: - Public Properties

    var onFetchExchanges: (() -> Void)?
    var onSearch: ((String) -> Void)?
    var openDetails: ((ExchangeInfoModel) -> ())?

    // MARK: - View Elements

    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.background.withAlphaComponent(0.95)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = StringHelper.title
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "exchangesTitleLabel"
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var searchBar: UITextField = {
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundColor = AppColors.surface
        search.textColor = AppColors.textPrimary
        search.layer.cornerRadius = 12
        search.font = UIFont.systemFont(ofSize: 14)
        search.accessibilityIdentifier = "searchBar"
        search.tintColor = AppColors.primary
        
        // Search icon
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        let iconLabel = UILabel(frame: CGRect(x: 12, y: 0, width: 20, height: 20))
        iconLabel.text = "🔍"
        iconLabel.font = UIFont.systemFont(ofSize: 14)
        iconView.addSubview(iconLabel)
        search.leftView = iconView
        search.leftViewMode = .always
        
        search.attributedPlaceholder = NSAttributedString(
            string: StringHelper.placeholderSearch,
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.textMuted]
        )
        search.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        return search
    }()
    
    private lazy var infoBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = StringHelper.infoTopExchanges
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = AppColors.textMuted
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var globalVolLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: StringHelper.infoGlobalVol, "--")
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = AppColors.textMuted
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "globalVolLabel"
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var headerSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.border
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.accessibilityIdentifier = "tableView"
        tableView.register(ExchangeTableViewCell.self, forCellReuseIdentifier: String(describing: ExchangeTableViewCell.self))
        tableView.register(SkeletonExchangeCell.self, forCellReuseIdentifier: String(describing: SkeletonExchangeCell.self))
        return tableView
    }()

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)
        backgroundColor = AppColors.background
        buildHierarchy()
        buildConstraints()
        setupSkeletonDataSource()
        setupKeyboardDismiss()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Private methods

    private func buildHierarchy() {
        addSubview(tableView)
        addSubview(headerView)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(searchBar)
        headerView.addSubview(headerSeparator)
        
        addSubview(infoBar)
        infoBar.addSubview(infoLabel)
        infoBar.addSubview(globalVolLabel)
    }

    private func buildConstraints() {
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            headerSeparator.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            headerSeparator.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerSeparator.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            headerSeparator.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // Info bar
            infoBar.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            infoBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoBar.heightAnchor.constraint(equalToConstant: 40),
            
            infoLabel.leadingAnchor.constraint(equalTo: infoBar.leadingAnchor, constant: 20),
            infoLabel.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor),
            
            globalVolLabel.trailingAnchor.constraint(equalTo: infoBar.trailingAnchor, constant: -20),
            globalVolLabel.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor),
            
            // Table
            tableView.topAnchor.constraint(equalTo: infoBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupSkeletonDataSource() {
        isShowingSkeleton = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    private func setupKeyboardDismiss() {
        keyboardDismissTap.install(on: self, ignoring: [searchBar])
    }

    @objc
    private func searchTextFieldDidChange(_ textField: UITextField?) {
        searchDelay?.invalidate()
        let text = textField?.text ?? ""
        searchDelay = Timer.scheduledTimer(
            timeInterval: delayStartSearch,
            target: self,
            selector: #selector(handleSearchDelayTimer(_:)),
            userInfo: text,
            repeats: false
        )
    }

    @objc
    private func handleSearchDelayTimer(_ timer: Timer) {
        let text = timer.userInfo as? String ?? ""
        onSearch?(text)
    }
}

// MARK: - ExchangesViewProtocol

extension ExchangesView: ExchangesViewProtocol {
    func setupTableView(dataSource: ExchangesDataSourceProtocol) {
        isShowingSkeleton = false
        dataSource.isLoadingMore = false
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()

        dataSource.openDetails = { [weak self] exchange in
            self?.endEditing(true)
            self?.openDetails?(exchange)
        }
    }

    func loadingView(isLoading: Bool) {
        if isLoading {
            setupSkeletonDataSource()
        }
    }

    func loadingMore(isLoading: Bool) {
        guard let dataSource = tableView.dataSource as? ExchangesDataSourceProtocol else { return }
        dataSource.isLoadingMore = isLoading
        
        tableView.reloadData()
    }

    func updateTotalVolume(_ totalVolume: Double) {
        let formatted = formatTotalVolume(totalVolume)
        globalVolLabel.text = String(format: StringHelper.infoGlobalVol, formatted)
    }

    private func formatTotalVolume(_ value: Double) -> String {
        if value >= 1_000_000_000 {
            return String(format: "$%.1fB", value / 1_000_000_000)
        } else if value >= 1_000_000 {
            return String(format: "$%.1fM", value / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "$%.1fK", value / 1_000)
        } else {
            return String(format: "$%.0f", value)
        }
    }
}

// MARK: - Skeleton DataSource

extension ExchangesView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SkeletonExchangeCell.self), for: indexPath) as? SkeletonExchangeCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
