//
//  ExchangeDetailViewModelTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 18/02/26.
//

import XCTest
@testable import AppMB

final class ExchangeDetailViewModelTests: XCTestCase {
    
    var sut: ExchangeDetailViewModel!
    var mockManager: MarketManagerMock!
    var mockDelegate: ExchangeDetailViewModelDelegateMock!
    var exchange: ExchangeInfoModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        exchange = try XCTUnwrap(ExchangeInfoModel.fixture().first)
        mockManager = MarketManagerMock()
        sut = ExchangeDetailViewModel(exchange: exchange, manager: mockManager)
        mockDelegate = ExchangeDetailViewModelDelegateMock()
        sut.delegate = mockDelegate
    }

    override func tearDown() {
        sut = nil
        mockManager = nil
        mockDelegate = nil
        exchange = nil
        super.tearDown()
    }

    func testFetchAssetsSuccess() async {
        // Given
        let mockAssets = [ExchangeAssetModel.fixture()]
        mockManager.fetchExchangeAssetsResult = .success(mockAssets)
        
        // When
        await sut.fetchAssets()
        
        // Then
        XCTAssertTrue(mockDelegate.assetsFetched)
        XCTAssertEqual(sut.assets.count, 1)
        XCTAssertEqual(sut.assets.first?.currency.name, "Bitcoin")
        XCTAssertEqual(mockManager.fetchAssetsCount, 1)
        XCTAssertEqual(mockManager.lastAssetId, exchange.id)
    }

    func testFetchAssetsFailure() async {
        // Given
        let error = NetworkError.serverError
        mockManager.fetchExchangeAssetsResult = .failure(error)
        
        // When
        await sut.fetchAssets()
        
        // Then
        XCTAssertFalse(mockDelegate.assetsFetched)
        XCTAssertEqual(mockDelegate.errorTitle, StringHelper.errorTitleSorry)
        XCTAssertEqual(mockDelegate.errorMessage, StringHelper.errorLoadMessage)
        XCTAssertEqual(mockManager.fetchAssetsCount, 1)
    }
}
