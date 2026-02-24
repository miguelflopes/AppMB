//
//  ExchangesViewTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

@MainActor
final class ExchangesViewTests: XCTestCase {
    func testSetupTableViewSetsDataSourceAndDelegate() {
        let view = ExchangesView()
        let dataSource = ExchangesDataSource()
        
        view.setupTableView(dataSource: dataSource)
        
        let tableView = view.findSubview(withAccessibilityIdentifier: "tableView") as? UITableView
        XCTAssertNotNil(tableView)
        XCTAssertTrue(tableView?.dataSource === dataSource)
        XCTAssertTrue(tableView?.delegate === dataSource)
    }
    
    func testLoadingViewResetsToSkeletonDataSource() {
        let view = ExchangesView()
        let dataSource = ExchangesDataSource()
        view.setupTableView(dataSource: dataSource)
        
        view.loadingView(isLoading: true)
        
        let tableView = view.findSubview(withAccessibilityIdentifier: "tableView") as? UITableView
        XCTAssertNotNil(tableView)
        XCTAssertTrue(tableView?.dataSource === view)
    }
    
    func testLoadingMoreUpdatesDataSourceFlag() {
        let view = ExchangesView()
        let dataSource = ExchangesDataSource()
        view.setupTableView(dataSource: dataSource)
        
        view.loadingMore(isLoading: true)
        XCTAssertTrue(dataSource.isLoadingMore)
    }
    
    func testUpdateTotalVolumeUpdatesLabel() {
        let view = ExchangesView()
        view.updateTotalVolume(1_500_000)
        
        let label = view.findSubview(withAccessibilityIdentifier: "globalVolLabel") as? UILabel
        let expected = String(format: StringHelper.infoGlobalVol, "$1.5M")
        XCTAssertEqual(label?.text, expected)
    }
}
