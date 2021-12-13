//
//  PulseAnimationLayerExtension.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.12.2021.
//

import Foundation
import QuartzCore
import UIKit

extension CALayer {
    func animatePulse(){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 0.6
        animation.fromValue = 1.0
        animation.toValue = 1.008
        animation.autoreverses = true
        animation.repeatCount = 1
        animation.initialVelocity = 0.5
        animation.damping = 0.8

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 2
        animationGroup.animations = [animation]

        self.add(animationGroup, forKey: "pulseAnimation")
    }
}
