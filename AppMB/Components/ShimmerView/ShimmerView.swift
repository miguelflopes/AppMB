//
//  ShimmerView.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import UIKit

@MainActor
final class ShimmerView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmer()
    }
    
    private func setupShimmer() {
        backgroundColor = AppColors.shimmerBase
        layer.cornerRadius = 6
        clipsToBounds = true
        
        gradientLayer.colors = [
            AppColors.shimmerBase.cgColor,
            AppColors.shimmerHighlight.cgColor,
            AppColors.shimmerBase.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)
        startAnimation()
    }
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width * 2
        animation.toValue = bounds.width * 2
        animation.duration = 1.5
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation, forKey: "shimmer")
    }
}
