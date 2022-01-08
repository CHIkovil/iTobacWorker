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
        var viewSetup: ViewSetup?
    }
    
    struct Graph {
        let line: CAShapeLayer
        let points: [CAShapeLayer]
        let clipping: CAShapeLayer
    }
    
    struct ViewSetup {
        let width: CGFloat
        let height: CGFloat
        let graphMaxValue: Int
    }
}

typealias GraphSetup = GraphModel.GraphSetup
typealias Graph = GraphModel.Graph
typealias ViewSetup = GraphModel.ViewSetup
