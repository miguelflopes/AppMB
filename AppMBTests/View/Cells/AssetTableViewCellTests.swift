//
//  AssetTableViewCellTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

@MainActor
final class AssetTableViewCellTests: XCTestCase {
    func testSetupPopulatesLabelsForSmallPrice() {
        let cell = AssetTableViewCell(style: .default, reuseIdentifier: "AssetCell")
        let asset = ExchangeAssetModel(
            balance: 1,
            platform: nil,
            currency: CurrencyDetail(
                cryptoId: 1,
                priceUSD: 0.000123,
                symbol: "BTC",
                name: "Bitcoin"
            )
        )
        
        cell.setup(with: asset)
        
        XCTAssertFalse(cell.contentView.findLabels(containing: "Bitcoin").isEmpty)
        XCTAssertFalse(cell.contentView.findLabels(containing: "BTC").isEmpty)
        XCTAssertFalse(cell.contentView.findLabels(containing: "$0.000123").isEmpty)
    }
}
