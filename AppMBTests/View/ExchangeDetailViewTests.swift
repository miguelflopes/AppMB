//
//  ExchangeDetailViewTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

@MainActor
final class ExchangeDetailViewTests: XCTestCase {
    func testSetupViewPopulatesLabels() {
        let view = ExchangeDetailView()
        let exchange = ExchangeInfoModel(
            id: 1,
            name: "Binance",
            slug: "binance",
            description: nil,
            dateLaunched: "2017-07-14",
            logo: nil,
            urls: ExchangeInfoUrls(
                website: ["https://binance.com"],
                twitter: nil,
                blog: nil,
                chat: nil,
                fee: nil
            ),
            isActive: 1,
            spotVolumeUSD: nil,
            makerFee: 0.1,
            takerFee: 0.2
        )
        
        view.setupView(exchange: exchange)
        
        let nameLabel = view.findSubview(withAccessibilityIdentifier: "exchangeDetailNameLabel") as? UILabel
        XCTAssertEqual(nameLabel?.text, "Binance")
        
        let idLabel = view.findSubview(withAccessibilityIdentifier: "exchangeDetailIdLabel") as? UILabel
        let expectedId = String(format: StringHelper.labelIdPrefix, exchange.id)
        XCTAssertEqual(idLabel?.text, expectedId)
    }
    
    func testUpdateAssetsAdjustsTableHeight() {
        let view = ExchangeDetailView()
        view.updateAssets(count: 2)
        
        let tableView = view.findSubview(withAccessibilityIdentifier: "exchangeDetailAssetsTable") as? UITableView
        let heightConstraint = tableView?.constraints.first { $0.firstAttribute == .height }
        XCTAssertEqual(heightConstraint?.constant, 160)
    }

    func testUpdateAssetsWithZeroHidesAssetsTitle() {
        let view = ExchangeDetailView()
        view.updateAssets(count: 0)
        
        let titleLabel = view.findSubview(withAccessibilityIdentifier: "exchangeDetailAssetsTitleLabel") as? UILabel
        XCTAssertEqual(titleLabel?.isHidden, false)
        
        let tableView = view.findSubview(withAccessibilityIdentifier: "exchangeDetailAssetsTable") as? UITableView
        XCTAssertEqual(tableView?.isHidden, true)
    }
    
    func testSetupAssetsDataSourceAssignsDelegate() {
        let view = ExchangeDetailView()
        let dataSource = TableDataSourceMock()
        
        view.setupAssetsDataSource(dataSource)
        
        let tableView = view.findSubview(withAccessibilityIdentifier: "exchangeDetailAssetsTable") as? UITableView
        XCTAssertTrue(tableView?.dataSource === dataSource)
        XCTAssertTrue(tableView?.delegate === dataSource)
    }
}

private final class TableDataSourceMock: NSObject, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
}
