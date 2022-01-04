//
//  GraphModel.swift
//  iTobacWorker
//
//  Created by Nikolas on 01.01.2022.
//

import Foundation
import UIKit

enum GraphModel {
    struct GraphSetup{
        let points: [Int]
        let color: UIColor
        let annotation: String
    }
    
    struct Graph{
        let lines: CAShapeLayer
        let clipping: CAShapeLayer
        let points: [CAShapeLayer]
    }
}


typealias GraphSetup = GraphModel.GraphSetup
typealias Graph = GraphModel.Graph
