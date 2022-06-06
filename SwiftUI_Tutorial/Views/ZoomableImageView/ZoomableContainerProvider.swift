//
//  ZoomableContainerProvider.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 05/06/2022.
//

import SwiftUI

protocol ZoomableContainerProvider: AnyObject {
    var imageContainerView: UIView { get }
    func prepareForRemove(completion: (() -> Void)?)
}

extension ZoomableContainerProvider {
    func prepareForRemove(completion: (() -> Void)?) {
        let blurPadding: CGFloat = 5 * UIScreen.main.scale
        let animationDuration: TimeInterval = 0.24
        let blurAnimationRate: Double = 1.5
        let alphaAnimationRate: Double = 1.38
        let scaleFactor: CGFloat = 0.18
        
        let blurView = UIVisualEffectView()
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.frame = self.imageContainerView.bounds.insetBy(dx: -blurPadding, dy: -blurPadding)
        blurView.clipsToBounds = false
        self.imageContainerView.clipsToBounds = false
        self.imageContainerView.addSubview(blurView)
        
        let blurAnimator = UIViewPropertyAnimator(duration: animationDuration * blurAnimationRate, curve: .easeOut) {
            blurView.effect = UIBlurEffect(style: .prominent)
        }
        
        let scaleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) {
            self.imageContainerView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
        
        scaleAnimator.addCompletion { _ in completion?() }
        [blurAnimator, scaleAnimator].forEach { $0.startAnimation() }

        UIView.animate(
            withDuration: animationDuration * alphaAnimationRate,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.imageContainerView.alpha = 0
            },
            completion: { _ in
                blurAnimator.stopAnimation(true)
                blurView.removeFromSuperview()
        })
    }
}
