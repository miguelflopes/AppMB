//
//  SkeletonExchangeCell.swift
//  AppMB
//
//  Created by Miguel Lopes on 24/02/26.
//

import UIKit

@MainActor
final class SkeletonExchangeCell: UITableViewCell {
    
    private let logoShimmer = ShimmerView()
    private let nameLine = ShimmerView()
    private let badgeLine = ShimmerView()
    private let subtitleLine = ShimmerView()
    private let valueLine = ShimmerView()
    private let valueSubLine = ShimmerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    private func setupViews() {
        [logoShimmer, nameLine, badgeLine, subtitleLine, valueLine, valueSubLine].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        logoShimmer.layer.cornerRadius = 24
        
        NSLayoutConstraint.activate([
            logoShimmer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoShimmer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoShimmer.widthAnchor.constraint(equalToConstant: 48),
            logoShimmer.heightAnchor.constraint(equalToConstant: 48),
            
            nameLine.leadingAnchor.constraint(equalTo: logoShimmer.trailingAnchor, constant: 16),
            nameLine.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            nameLine.widthAnchor.constraint(equalToConstant: 96),
            nameLine.heightAnchor.constraint(equalToConstant: 16),
            
            badgeLine.leadingAnchor.constraint(equalTo: nameLine.trailingAnchor, constant: 8),
            badgeLine.centerYAnchor.constraint(equalTo: nameLine.centerYAnchor),
            badgeLine.widthAnchor.constraint(equalToConstant: 30),
            badgeLine.heightAnchor.constraint(equalToConstant: 14),
            
            subtitleLine.leadingAnchor.constraint(equalTo: logoShimmer.trailingAnchor, constant: 16),
            subtitleLine.topAnchor.constraint(equalTo: nameLine.bottomAnchor, constant: 6),
            subtitleLine.widthAnchor.constraint(equalToConstant: 80),
            subtitleLine.heightAnchor.constraint(equalToConstant: 14),
            
            valueLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            valueLine.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            valueLine.widthAnchor.constraint(equalToConstant: 64),
            valueLine.heightAnchor.constraint(equalToConstant: 16),
            
            valueSubLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            valueSubLine.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2),
            valueSubLine.widthAnchor.constraint(equalToConstant: 48),
            valueSubLine.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
}
