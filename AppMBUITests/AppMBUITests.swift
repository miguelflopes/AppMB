//
//  AppMBUITests.swift
//  AppMBUITests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest

final class AppMBUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAppLaunchAndExchangesList() throws {
        let titleLabel = app.staticTexts["exchangesTitleLabel"]
        XCTAssertTrue(titleLabel.exists)
        
        let searchBar = app.textFields["searchBar"]
        XCTAssertTrue(searchBar.exists)
        
        let tableView = app.tables["tableView"]
        XCTAssertTrue(tableView.exists)
    }
    
    func testSearchBarAcceptsInput() throws {
        let searchBar = app.textFields["searchBar"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 2))
        
        searchBar.tap()
        searchBar.typeText("test")
        
        let value = searchBar.value as? String
        XCTAssertEqual(value, "test")
    }
    
    func testOpenDetailShowsExchangeInfo() throws {
        let tableView = app.tables["tableView"]
        XCTAssertTrue(tableView.waitForExistence(timeout: 2))

        let maxAttempts = 5
        for index in 0..<maxAttempts {
            let cell = tableView.cells.element(boundBy: index)
            guard cell.waitForExistence(timeout: 4) else { continue }
            cell.tap()

            let nameLabel = app.staticTexts["exchangeDetailNameLabel"]
            XCTAssertTrue(nameLabel.waitForExistence(timeout: 2))

            let idLabel = app.staticTexts["exchangeDetailIdLabel"]
            XCTAssertTrue(idLabel.exists)

            let assetsTable = app.tables["exchangeDetailAssetsTable"]
            if assetsTable.waitForExistence(timeout: 2),
               assetsTable.cells.element(boundBy: 0).waitForExistence(timeout: 2) {
                return
            }

            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            XCTAssertTrue(backButton.waitForExistence(timeout: 2))
            backButton.tap()
            XCTAssertTrue(tableView.waitForExistence(timeout: 2))
        }

        XCTFail("No exchange with assets found in the first \(maxAttempts) items.")
    }
}
