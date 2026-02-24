//
//  LoadingViewTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

@MainActor
final class LoadingViewTests: XCTestCase {
    func testShowAndHideChangesVisibility() {
        let view = LoadingView(frame: .zero)
        view.hiden()
        XCTAssertTrue(view.isHidden)
        
        view.show()
        XCTAssertFalse(view.isHidden)
    }
}
