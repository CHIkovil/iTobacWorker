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
    
    func drawBlockLayer(cornerWidth: CGFloat, color: UIColor) {
        self.sublayers?.forEach {
            if ($0.name == "block"){
                $0.removeFromSuperlayer()
            }
        }
        
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.allCorners],
            cornerRadii: CGSize(width: cornerWidth, height: 0.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.name = "block"
       
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = .zero
        self.shadowRadius = 10
        
    
        self.insertSublayer(shapeLayer, at: 0)
    }
    
    func drawBorder(_ cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.borderWidth = 4
        self.borderColor = #colorLiteral(red: 0.08958115429, green: 0.08975156397, blue: 0.09752175957, alpha: 1)
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 1
        self.shadowOffset = .zero
        self.shadowRadius = 10
    }
    
    //MARK: ANIMATION
    
    func addPulseAnimation(){
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 1
        animation.fromValue = 1.0
        animation.toValue = 1.01
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
    
    func addActivationAnimation(){
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1
    
        self.add(animation, forKey:"strokeEnd")
    }
}
