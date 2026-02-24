//
//  ExchangeDetailView.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

@MainActor
final class ExchangeDetailView: UIView {
    
    // MARK: - View Elements
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Header
    
    private lazy var logoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 48
        view.layer.borderWidth = 4
        view.layer.borderColor = AppColors.border.cgColor
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 40
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "exchangeDetailNameLabel"
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var badgesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var idBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = AppColors.textSecondary
        label.backgroundColor = AppColors.badgeGrayBg
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        label.accessibilityIdentifier = "exchangeDetailIdLabel"
        label.isAccessibilityElement = true
        return label
    }()
    
    // MARK: Info Grid
    
    private lazy var infoGrid: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: About Section
    
    private lazy var aboutTitle: UILabel = {
        let label = UILabel()
        label.text = StringHelper.titleAbout
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.cardBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.cardBorder.cgColor
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = AppColors.textSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = AppColors.primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Assets Section
    
    private lazy var assetsHeaderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var assetsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringHelper.titleAvailableAssets
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.accessibilityIdentifier = "exchangeDetailAssetsTitleLabel"
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var assetsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.register(AssetTableViewCell.self, forCellReuseIdentifier: "AssetCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.accessibilityIdentifier = "exchangeDetailAssetsTable"
        return table
    }()
    private var logoTask: Task<Void, Never>?
    private var websiteURL: URL?

    // MARK: - Public Properties
    var onOpenWebsite: ((URL) -> Void)?

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)
        backgroundColor = AppColors.background
        buildHierarchy()
        buildConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    deinit {
        logoTask?.cancel()
    }
    
    // MARK: - Private methods

    private func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoContainer)
        logoContainer.addSubview(logoImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(badgesStack)
        
        badgesStack.addArrangedSubview(idBadge)
        
        contentView.addSubview(infoGrid)
        contentView.addSubview(aboutTitle)
        contentView.addSubview(aboutCard)
        aboutCard.addSubview(descriptionLabel)
        aboutCard.addSubview(websiteLabel)
        
        contentView.addSubview(assetsHeaderStack)
        assetsHeaderStack.addArrangedSubview(assetsTitleLabel)
        contentView.addSubview(assetsTableView)
    }

    private func buildConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            logoContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 96),
            logoContainer.heightAnchor.constraint(equalToConstant: 96),
            
            logoImage.leadingAnchor.constraint(equalTo: logoContainer.leadingAnchor, constant: 4),
            logoImage.trailingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: -4),
            logoImage.topAnchor.constraint(equalTo: logoContainer.topAnchor, constant: 4),
            logoImage.bottomAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: -4),
            
            nameLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            badgesStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            badgesStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            idBadge.heightAnchor.constraint(equalToConstant: 24),
            idBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            infoGrid.topAnchor.constraint(equalTo: badgesStack.bottomAnchor, constant: 20),
            infoGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            infoGrid.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            infoGrid.heightAnchor.constraint(equalToConstant: 80),
            
            aboutTitle.topAnchor.constraint(equalTo: infoGrid.bottomAnchor, constant: 32),
            aboutTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            aboutCard.topAnchor.constraint(equalTo: aboutTitle.bottomAnchor, constant: 12),
            aboutCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            aboutCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            descriptionLabel.topAnchor.constraint(equalTo: aboutCard.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: aboutCard.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: aboutCard.trailingAnchor, constant: -16),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            websiteLabel.leadingAnchor.constraint(equalTo: aboutCard.leadingAnchor, constant: 16),
            websiteLabel.bottomAnchor.constraint(equalTo: aboutCard.bottomAnchor, constant: -16),
            
            assetsHeaderStack.topAnchor.constraint(equalTo: aboutCard.bottomAnchor, constant: 32),
            assetsHeaderStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            assetsHeaderStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            assetsTableView.topAnchor.constraint(equalTo: assetsHeaderStack.bottomAnchor, constant: 12),
            assetsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            assetsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            assetsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            assetsTableView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupWebsiteTap() {
        if websiteLabel.gestureRecognizers?.isEmpty == false { return }
        websiteLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleWebsiteTap))
        websiteLabel.addGestureRecognizer(tap)
    }
    
    private func createInfoCard(title: String, value: String) -> UIView {
        let card = UIView()
        card.backgroundColor = AppColors.cardBackground
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 1
        card.layer.borderColor = AppColors.cardBorder.cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        titleLabel.textColor = AppColors.textMuted
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        valueLabel.textColor = AppColors.textPrimary
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(titleLabel)
        card.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor)
        ])
        
        return card
    }

    private func setLogo(_ logo: String?) {
        logoTask?.cancel()
        logoImage.image = nil

        guard let logoUrlStr = logo, let logoUrl = URL(string: logoUrlStr) else { return }

        logoTask = Task { [weak self] in
            guard let self else { return }

            do {
                let data = try await DownloadImage.shared.loadData(url: logoUrl)
                try Task.checkCancellation()
                self.logoImage.image = UIImage(data: data)
            } catch is CancellationError {
                return
            } catch {
                self.logoImage.image = nil
            }
        }
    }

    private func setUrl(_ urls: [String]?) {
        if let first = urls?.first, let url = URL(string: first) {
            websiteURL = url
            websiteLabel.text = "🌐 \(first.cleanedURL)"
        } else {
            websiteURL = nil
            websiteLabel.text = ""
        }
    }

    private func setInfoGrid(
        dateLaunched: String?,
        makerFee: Double?,
        takerFee: Double?
    ) {
        infoGrid.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let launchYear: String
        if let date = dateLaunched {
            launchYear = String(date.prefix(4))
        } else {
            launchYear = StringHelper.labelNotAvailable
        }

        let makerFeeText = makerFee.map { String(format: "%.2f%%", $0) } ?? StringHelper.labelNotAvailable
        let takerFeeText = takerFee.map { String(format: "%.2f%%", $0) } ?? StringHelper.labelNotAvailable

        infoGrid.addArrangedSubview(createInfoCard(title: StringHelper.titleMakerFee, value: makerFeeText))
        infoGrid.addArrangedSubview(createInfoCard(title: StringHelper.titleTakerFee, value: takerFeeText))
        infoGrid.addArrangedSubview(createInfoCard(title: StringHelper.titleLaunched, value: launchYear))
    }

    // MARK: - Public Methods
    
    func setupView(exchange: ExchangeInfoModel) {
        setupWebsiteTap()
        setLogo(exchange.logo)
        nameLabel.text = exchange.name
        idBadge.text = String(format: StringHelper.labelIdPrefix, exchange.id)

        setInfoGrid(
            dateLaunched: exchange.dateLaunched,
            makerFee: exchange.makerFee,
            takerFee: exchange.takerFee
        )
        descriptionLabel.text = exchange.description ?? StringHelper.emptyDescription
        setUrl(exchange.urls?.website)
    }

    func updateAssets(count: Int) {
        let shouldHideAssets = count == 0
        assetsHeaderStack.isHidden = shouldHideAssets
        assetsTableView.isHidden = shouldHideAssets
        let totalHeight = CGFloat(count * 80)
        let tableHeightConstraint = assetsTableView.constraints.first { $0.firstAttribute == .height }
        tableHeightConstraint?.constant = shouldHideAssets ? 0 : totalHeight
        assetsTableView.reloadData()
        layoutIfNeeded()
    }
    
    func setupAssetsDataSource(_ dataSource: UITableViewDataSource & UITableViewDelegate) {
        assetsTableView.dataSource = dataSource
        assetsTableView.delegate = dataSource
    }
}

// MARK: - Actions

private extension ExchangeDetailView {
    @objc
    func handleWebsiteTap() {
        guard let url = websiteURL else { return }
        onOpenWebsite?(url)
    }
}
