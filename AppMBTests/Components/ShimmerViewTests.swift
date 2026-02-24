//
//  ShimmerViewTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
import UIKit
@testable import AppMB

@MainActor
final class ShimmerViewTests: XCTestCase {
    func testShimmerViewAddsGradientLayer() {
        let view = ShimmerView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        view.layoutSubviews()
        
        let hasGradient = view.layer.sublayers?.contains(where: { $0 is CAGradientLayer }) ?? false
        XCTAssertTrue(hasGradient)
    }
    
    func testSkeletonExchangeCellInitAddsSubviews() {
        let cell = SkeletonExchangeCell(style: .default, reuseIdentifier: "Skeleton")
        XCTAssertFalse(cell.contentView.subviews.isEmpty)
    }
}
