//
//  ExchangeTableViewCellTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

@MainActor
final class ExchangeTableViewCellTests: XCTestCase {
    func testSetupViewSetsExpectedLabels() {
        let cell = ExchangeTableViewCell(style: .default, reuseIdentifier: "cell")
        let exchange = ExchangeInfoModel(
            id: 1,
            name: "Binance",
            slug: "binance",
            description: nil,
            dateLaunched: "2017-07-14",
            logo: nil,
            urls: nil,
            isActive: 1,
            spotVolumeUSD: 1_000_000
        )
        let viewModel = ExchangeCellViewModel(exchange: exchange, rank: 1)
        
        cell.setupView(viewModel: viewModel)
        
        XCTAssertFalse(cell.contentView.findLabels(containing: "Binance").isEmpty)
        let expectedSubtitle = String(format: StringHelper.labelLaunchedCell, "2017")
        XCTAssertFalse(cell.contentView.findLabels(containing: expectedSubtitle).isEmpty)
        XCTAssertFalse(cell.contentView.findLabels(containing: viewModel.volumeValue).isEmpty)
    }
    
    func testPrepareForReuseClearsLabelTexts() {
        let cell = ExchangeTableViewCell(style: .default, reuseIdentifier: "cell")
        let exchange = ExchangeInfoModel(
            id: 1,
            name: "Binance",
            slug: "binance",
            description: nil,
            dateLaunched: "2017-07-14",
            logo: nil,
            urls: nil,
            isActive: 1,
            spotVolumeUSD: 1_000_000
        )
        let viewModel = ExchangeCellViewModel(exchange: exchange, rank: 1)
        cell.setupView(viewModel: viewModel)
        
        cell.prepareForReuse()
        
        XCTAssertTrue(cell.contentView.findLabels(containing: "Binance").isEmpty)
    }
}
