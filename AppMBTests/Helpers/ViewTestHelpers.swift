//
//  ViewTestHelpers.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import UIKit

extension UIView {
    func findSubview<T: UIView>(ofType type: T.Type) -> T? {
        if let view = self as? T {
            return view
        }
        for subview in subviews {
            if let found = subview.findSubview(ofType: type) {
                return found
            }
        }
        return nil
    }
    
    func findSubview(withAccessibilityIdentifier identifier: String) -> UIView? {
        if accessibilityIdentifier == identifier {
            return self
        }
        for subview in subviews {
            if let found = subview.findSubview(withAccessibilityIdentifier: identifier) {
                return found
            }
        }
        return nil
    }
    
    func findLabels(containing text: String) -> [UILabel] {
        var results: [UILabel] = []
        if let label = self as? UILabel, label.text?.contains(text) == true {
            results.append(label)
        }
        for subview in subviews {
            results.append(contentsOf: subview.findLabels(containing: text))
        }
        return results
    }
}
