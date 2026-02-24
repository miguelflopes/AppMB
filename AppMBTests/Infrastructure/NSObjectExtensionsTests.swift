//
//  NSObjectExtensionsTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

final class NSObjectExtensionsTests: XCTestCase {
    func testClassNameReturnsTypeName() {
        XCTAssertEqual(UIView.className, "UIView")
    }
}
