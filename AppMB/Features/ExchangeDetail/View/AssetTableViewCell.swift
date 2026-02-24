//
//  AssetTableViewCell.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

@MainActor
final class AssetTableViewCell: UITableViewCell {
    
    // MARK: - View Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.cardBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = AppColors.textMuted
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(symbolLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(changeLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.heightAnchor.constraint(equalToConstant: 72),

            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),

            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),

            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),

            changeLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4)
        ])
    }

    // MARK: - Public Methods
    
    func setup(with asset: ExchangeAssetModel) {
        nameLabel.text = asset.currency.name
        symbolLabel.text = asset.currency.symbol
        
        let priceValue = asset.currency.priceUSD
        if priceValue < 1.0 {
            priceLabel.text = String(format: "$%.6f", priceValue)
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 2
            priceLabel.text = formatter.string(from: NSNumber(value: priceValue))
        }
        changeLabel.text = nil
        changeLabel.textColor = AppColors.textMuted
    }
}
