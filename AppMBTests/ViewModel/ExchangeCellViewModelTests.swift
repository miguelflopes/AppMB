//
//  ExchangeCellViewModelTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 18/02/26.
//

import XCTest
@testable import AppMB

final class ExchangeCellViewModelTests: XCTestCase {
    
    func testInitializationWithRank1AndHighVolume() {
        // Given
        let exchange = ExchangeInfoModel(
            id: 1, 
            name: "Binance", 
            slug: "binance", 
            description: nil, 
            dateLaunched: "2017-07-01", 
            logo: "url", 
            urls: nil, 
            isActive: 1,
            spotVolumeUSD: 14_500_000_000.0
        )
        
        // When
        let sut = ExchangeCellViewModel(exchange: exchange, rank: 1)
        
        // Then
        XCTAssertEqual(sut.name, "Binance")
        XCTAssertEqual(sut.subtitle, "Launched 2017")
        XCTAssertEqual(sut.rankText, " #1 ")
        XCTAssertEqual(sut.rankBadgeColor, AppColors.badgeYellowBg)
        XCTAssertEqual(sut.volumeValue, "$14.5B")
    }
    
    func testInitializationWithMillionsVolume() {
        // Given
        let exchange = ExchangeInfoModel(
            id: 200, 
            name: "Generic", 
            slug: "generic", 
            description: nil, 
            dateLaunched: nil, 
            logo: nil, 
            urls: nil, 
            isActive: 1,
            spotVolumeUSD: 450_200_000.0
        )
        
        // When
        let sut = ExchangeCellViewModel(exchange: exchange, rank: 25)
        
        // Then
        XCTAssertEqual(sut.name, "Generic")
        XCTAssertEqual(sut.rankText, " #25 ")
        XCTAssertEqual(sut.volumeValue, "$450.2M")
    }
    
    func testInitializationWithNoVolume() {
        // Given
        let exchange = ExchangeInfoModel(
            id: 300, 
            name: "New", 
            slug: "new", 
            description: nil, 
            dateLaunched: nil, 
            logo: nil, 
            urls: nil, 
            isActive: 1,
            spotVolumeUSD: nil
        )
        
        // When
        let sut = ExchangeCellViewModel(exchange: exchange, rank: 100)
        
        // Then
        XCTAssertEqual(sut.volumeValue, "--")
    }
    
    func testLogoURLLogic() {
        // Given
        let exchangeNoLogo = ExchangeInfoModel(id: 42, name: "X", slug: "x", description: nil, dateLaunched: nil, logo: "https://s2.coinmarketcap.com", urls: nil, isActive: 1, spotVolumeUSD: nil)

        // When
        let sutNoLogo = ExchangeCellViewModel(exchange: exchangeNoLogo, rank: 1)
        
        // Then
        XCTAssertEqual(sutNoLogo.logoURL?.absoluteString, "https://s2.coinmarketcap.com")
    }
}
