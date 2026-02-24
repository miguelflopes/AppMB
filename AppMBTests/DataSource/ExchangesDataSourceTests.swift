//
//  ExchangesDataSourceTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

@MainActor
final class ExchangesDataSourceTests: XCTestCase {
    func testNumberOfRowsWhenLoadingMoreAddsSkeletonCell() {
        let sut = ExchangesDataSource()
        sut.exchanges = [ExchangeInfoModel(id: 1, name: "A", slug: "a", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: nil)]
        
        sut.isLoadingMore = false
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
        
        sut.isLoadingMore = true
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
    }
    
    func testCellForRowAtReturnsSkeletonWhenLoadingMore() {
        let sut = ExchangesDataSource()
        sut.exchanges = [ExchangeInfoModel(id: 1, name: "A", slug: "a", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: nil)]
        sut.isLoadingMore = true
        
        let tableView = UITableView()
        tableView.register(SkeletonExchangeCell.self, forCellReuseIdentifier: String(describing: SkeletonExchangeCell.self))
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssertTrue(cell is SkeletonExchangeCell)
    }
    
    func testWillDisplayLastRowTriggersLoadMore() {
        let sut = ExchangesDataSource()
        sut.exchanges = [
            ExchangeInfoModel(id: 1, name: "A", slug: "a", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: nil),
            ExchangeInfoModel(id: 2, name: "B", slug: "b", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: nil)
        ]
        
        var loadMoreCalled = false
        sut.loadMore = { loadMoreCalled = true }
        
        sut.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: 0))
        XCTAssertTrue(loadMoreCalled)
    }
    
    func testDidSelectRowCallsOpenDetails() {
        let sut = ExchangesDataSource()
        let exchange = ExchangeInfoModel(id: 99, name: "Z", slug: "z", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: nil)
        sut.exchanges = [exchange]
        
        var selected: ExchangeInfoModel?
        sut.openDetails = { selected = $0 }
        
        sut.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(selected?.id, 99)
    }
    
    func testHeightForRowIsFixed() {
        let sut = ExchangesDataSource()
        let height = sut.tableView(UITableView(), heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(height, 92)
    }
}
