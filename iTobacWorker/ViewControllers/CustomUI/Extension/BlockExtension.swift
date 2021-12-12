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
    func drawBlockLayer() {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.allCorners],
            cornerRadii: CGSize(width: 35, height: 0.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.2052714825, green: 0.205650717, blue: 0.2234534323, alpha: 1).cgColor
        self.insertSublayer(shapeLayer, at: 0)
    }
}
