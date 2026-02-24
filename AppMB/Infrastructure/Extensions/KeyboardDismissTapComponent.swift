//
//  KeyboardDismissTapComponent.swift
//  AppMB
//
//  Created by Miguel Lopes on 24/02/26.
//

import UIKit

private final class KeyboardDismissTapDelegate: NSObject, UIGestureRecognizerDelegate {
    var ignoredViews: [UIView]

    init(ignoredViews: [UIView]) {
        self.ignoredViews = ignoredViews
        super.init()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return true }
        return !ignoredViews.contains { view.isDescendant(of: $0) }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

final class KeyboardDismissTapComponent: NSObject {
    private let tap: UITapGestureRecognizer
    private let delegateProxy: KeyboardDismissTapDelegate

    override init() {
        delegateProxy = KeyboardDismissTapDelegate(ignoredViews: [])
        tap = UITapGestureRecognizer()
        super.init()
        tap.addTarget(self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        tap.delegate = delegateProxy
    }

    func install(on view: UIView, ignoring ignoredViews: [UIView] = []) {
        delegateProxy.ignoredViews = ignoredViews

        if let currentView = tap.view, currentView !== view {
            currentView.removeGestureRecognizer(tap)
        }

        if tap.view == nil {
            view.addGestureRecognizer(tap)
        }
    }

    @objc private func handleTap() {
        guard let rootView = tap.view, findFirstResponder(in: rootView) != nil else { return }
        rootView.endEditing(true)
    }

    private func findFirstResponder(in view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        for subview in view.subviews {
            if let responder = findFirstResponder(in: subview) {
                return responder
            }
        }
        return nil
    }
}
