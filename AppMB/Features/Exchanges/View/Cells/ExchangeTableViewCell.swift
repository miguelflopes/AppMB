//
//  ExchangeTableViewCell.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

@MainActor
final class ExchangeTableViewCell: UITableViewCell {
    
    // MARK: - View Elements
    
    private let logoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.border.cgColor
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rankBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColors.textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = AppColors.textPrimary
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = AppColors.primary
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.border.withAlphaComponent(0.5)
        return view
    }()
    private var imageTask: Task<Void, Never>?
    private var currentImageURL: URL?

    // MARK: - Initializers
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(logoContainer)
        logoContainer.addSubview(logoImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rankBadge)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(valueSubLabel)
        contentView.addSubview(separator)
        
        setupConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        currentImageURL = nil
        logoImage.image = nil
        nameLabel.text = nil
        subtitleLabel.text = nil
        rankBadge.text = nil
        valueLabel.text = nil
        valueSubLabel.text = nil
    }

    deinit {
        imageTask?.cancel()
    }
    
    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 48),
            logoContainer.heightAnchor.constraint(equalToConstant: 48),
            
            logoImage.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 36),
            logoImage.heightAnchor.constraint(equalToConstant: 36),

            nameLabel.leadingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            
            rankBadge.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            rankBadge.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            rankBadge.heightAnchor.constraint(equalToConstant: 18),
            rankBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 26),
            rankBadge.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueSubLabel.leadingAnchor, constant: -8),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            
            valueSubLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueSubLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2),
            
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
    }

    private func loadImage(url: URL?) {
        imageTask?.cancel()
        logoImage.image = nil
        currentImageURL = nil

        guard let url else { return }
        currentImageURL = url

        imageTask = Task { [weak self] in
            guard let self else { return }

            do {
                let data = try await DownloadImage.shared.loadData(url: url)
                try Task.checkCancellation()
                guard self.currentImageURL == url else { return }
                self.logoImage.image = UIImage(data: data)
            } catch is CancellationError {
                return
            } catch {
                guard self.currentImageURL == url else { return }
                self.logoImage.image = nil
            }
        }
    }
    
    // MARK: - Public Methods
    
    func setupView(viewModel: ExchangeCellViewModel) {
        nameLabel.text = viewModel.name
        subtitleLabel.text = viewModel.subtitle
        rankBadge.text = viewModel.rankText
        rankBadge.backgroundColor = viewModel.rankBadgeColor
        rankBadge.textColor = viewModel.rankBadgeTextColor
        valueLabel.text = viewModel.volumeValue
        valueSubLabel.text = viewModel.volumeSubLabel
        
        loadImage(url: viewModel.logoURL)
    }
}
