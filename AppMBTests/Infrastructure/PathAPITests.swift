//
//  PathAPITests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
@testable import AppMB

final class PathAPITests: XCTestCase {
    func testPathAPIValuesMatchConstants() {
        let sut = PathAPI()
        let constants = ApplicationConstants.PathAPI()
        
        XCTAssertEqual(sut.exchangeMap, constants.exchangeMap)
        XCTAssertEqual(sut.exchangeInfo, constants.exchangeInfo)
        XCTAssertEqual(sut.exchangeAssets, constants.exchangeAssets)
        XCTAssertEqual(sut.apiKey, ApplicationConstants.PathAPI.apiKey)
    }
}
