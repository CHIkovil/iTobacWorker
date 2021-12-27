//
//  BlockExtension.swift
//  iTobacWorker
//
//  Created by Nikolas on 13.12.2021.
//

import Foundation
import QuartzCore
import UIKit

extension CALayer{
    //MARK: DRAW
    func drawBlockLayer(cornerWidth: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.allCorners],
            cornerRadii: CGSize(width: cornerWidth, height: 0.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.1531058252, green: 0.1786891222, blue: 0.2617320716, alpha: 1).cgColor
       
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = .zero
        self.shadowRadius = 10
        
        self.insertSublayer(shapeLayer, at: 0)
    }
    
    //MARK: ANIMATION
    func addPulseAnimation(){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 0.6
        animation.fromValue = 1.0
        animation.toValue = 1.005
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
