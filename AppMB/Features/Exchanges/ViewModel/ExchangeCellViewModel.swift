//
//  ExchangeCellViewModel.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

struct ExchangeCellViewModel {
    let name: String
    let subtitle: String
    let rankText: String
    let rankBadgeColor: UIColor
    let rankBadgeTextColor: UIColor
    let volumeValue: String
    let volumeSubLabel: String
    let logoURL: URL?
    
    init(exchange: ExchangeInfoModel, rank: Int) {
        self.name = exchange.name
        
        if let date = exchange.dateLaunched {
            let year = String(date.prefix(4))
            self.subtitle = String(format: StringHelper.labelLaunchedCell, year)
        } else {
            self.subtitle = StringHelper.labelNotAvailable
        }
        
        self.rankText = " #\(rank) "
        if rank == 1 {
            self.rankBadgeColor = AppColors.badgeYellowBg
            self.rankBadgeTextColor = AppColors.badgeYellowText
        } else {
            self.rankBadgeColor = AppColors.badgeGrayBg
            self.rankBadgeTextColor = AppColors.badgeGrayText
        }
        
        if let volume = exchange.spotVolumeUSD {
            self.volumeValue = ExchangeCellViewModel.formatCurrency(volume)
        } else {
            self.volumeValue = "--"
        }

        self.volumeSubLabel = StringHelper.labelVolume24h
        self.logoURL = URL(string: exchange.logo ?? "")
    }
    
    // MARK: - Helper Formatting
    
    private static func formatCurrency(_ value: Double) -> String {
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
