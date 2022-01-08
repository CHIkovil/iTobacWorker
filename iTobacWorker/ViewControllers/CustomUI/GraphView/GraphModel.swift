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
    
    struct Graph {
        let line: CAShapeLayer
        let points: [CAShapeLayer]
        let clipping: CAShapeLayer
    }
}

typealias GraphSetup = GraphModel.GraphSetup
typealias Graph = GraphModel.Graph
