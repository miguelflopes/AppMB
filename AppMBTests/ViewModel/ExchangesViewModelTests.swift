//
//  ExchangesViewModelTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 18/02/26.
//

import XCTest
@testable import AppMB

final class ExchangesViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: ExchangesViewModel!
    var mockManager: MarketManagerMock!
    var mockDelegate: ExchangesViewModelDelegateMock!
    var mockExchanges: [ExchangeInfoModel]!

    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockManager = MarketManagerMock()
        sut = ExchangesViewModel(manager: mockManager)
        mockDelegate = ExchangesViewModelDelegateMock()
        sut.delegate = mockDelegate
        mockExchanges = ExchangeInfoModel.fixture()
    }
    
    override func tearDown() {
        sut = nil
        mockManager = nil
        mockDelegate = nil
        mockExchanges = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchExchangesSuccess() async {
        mockManager.fetchExchangesResult = .success(mockExchanges)

        await sut.fetchExchanges()
        XCTAssertEqual(mockDelegate.exchanges?.count, 3)
        XCTAssertEqual(mockDelegate.exchanges?.first?.name, "Binance")
        XCTAssertEqual(mockManager.fetchExchangesCount, 1)
        XCTAssertFalse(mockDelegate.isLoading)
    }
    
    func testFetchExchangesSuccessWithSorting() async {
        // Given
        let lowVolume = ExchangeInfoModel(id: 10, name: "Low", slug: "low", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: 100)
        let highVolume = ExchangeInfoModel(id: 20, name: "High", slug: "high", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: 1000)
        mockManager.fetchExchangesResult = .success([lowVolume, highVolume])
        
        // When
        await sut.fetchExchanges()
        
        // Then
        XCTAssertEqual(mockDelegate.exchanges?.first?.name, "High")
        XCTAssertEqual(mockDelegate.exchanges?.last?.name, "Low")
    }
    
    func testTotalVolumeCalculation() async {
        // Given
        let ex1 = ExchangeInfoModel(id: 1, name: "A", slug: "a", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: 1000)
        let ex2 = ExchangeInfoModel(id: 2, name: "B", slug: "b", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: 2000)
        mockManager.fetchExchangesResult = .success([ex1, ex2])
        
        // When
        await sut.fetchExchanges()
        
        // Then
        XCTAssertEqual(mockDelegate.lastTotalVolume, 3000)
    }
    
    func testFetchExchangesFailure() async {
        let error = NetworkError.invalidURL
        mockManager.fetchExchangesResult = .failure(error)
        
        await sut.fetchExchanges()
        XCTAssertEqual(mockDelegate.errorTitle, StringHelper.errorTitleSorry)
        XCTAssertEqual(mockDelegate.errorMessage, StringHelper.errorLoadMessage)
        XCTAssertEqual(mockManager.fetchExchangesCount, 1)
        XCTAssertFalse(mockDelegate.isLoading)
    }
    
    func testSearchFiltersExchanges() async {
        mockManager.fetchExchangesResult = .success(mockExchanges)

        await sut.fetchExchanges()
        
        await sut.search(search: "Binance")
        
        XCTAssertEqual(mockDelegate.exchanges?.count, 1)
        XCTAssertEqual(mockDelegate.exchanges?.first?.name, "Binance")
    }
    
    func testSearchEmptyReturnsAll() async {
        mockManager.fetchExchangesResult = .success(mockExchanges)

        await sut.fetchExchanges()
        
        await sut.search(search: "")
        
        XCTAssertEqual(mockDelegate.exchanges?.count, 3)
    }
    
    func testLoadMoreExchangesSuccess() async {
        // Given
        let initialExchanges = (1...20).map { index in
            ExchangeInfoModel(
                id: index,
                name: "Exchange \(index)",
                slug: "exchange-\(index)",
                description: nil,
                dateLaunched: nil,
                logo: nil,
                urls: nil,
                isActive: 1,
                spotVolumeUSD: 1_000_000_000 + Double(index)
            )
        }
        mockManager.fetchExchangesResult = .success(initialExchanges)

        await sut.fetchExchanges()
        
        let moreExchanges = [ExchangeInfoModel(id: 21, name: "Kraken", slug: "kraken", description: nil, dateLaunched: nil, logo: nil, urls: nil, isActive: 1, spotVolumeUSD: 2000000.0)]
        mockManager.fetchExchangesResult = .success(moreExchanges)
        
        // When
        await sut.loadMoreExchanges()
        
        // Then
        XCTAssertEqual(mockDelegate.exchanges?.count, 21)
        XCTAssertEqual(mockDelegate.exchanges?.last?.name, "Kraken")
        XCTAssertEqual(mockManager.fetchExchangesCount, 2)
        XCTAssertEqual(mockManager.lastStart, 21)
        XCTAssertEqual(mockManager.lastLimit, 20)
    }
}
