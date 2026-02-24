//
//  LoadingView.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

// MARK: - LoadingView

@MainActor
final class LoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.primary
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView() {
        backgroundColor = AppColors.background.withAlphaComponent(0.8)
        accessibilityIdentifier = "loadingView"
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func show() {
        self.isHidden = false
    }

    func hiden() {
        self.isHidden = true
    }
}
