//
//  StringExtensionsTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
@testable import AppMB

final class StringExtensionsTests: XCTestCase {
    func testFirstUppercased() {
        XCTAssertEqual("hello".firstUppercased, "Hello")
    }
    
    func testConvertStringToDate() {
        let input = "2024-01-10T12:00:00.000Z"
        XCTAssertEqual(input.convertStringToDate(), "10/01/2024")
    }
    
    func testConvertStringToDateInvalidReturnsOriginal() {
        let input = "invalid-date"
        XCTAssertEqual(input.convertStringToDate(), input)
    }
    
    func testReplaceStringToURL() {
        let url = "https://{id}.com".replaceStringToURL(occurrence: "{id}", with: "test")
        XCTAssertEqual(url?.absoluteString, "https://test.com")
    }
    
    func testCleanedURL() {
        let input = "https://example.com/"
        XCTAssertEqual(input.cleanedURL, "example.com")
    }
}
