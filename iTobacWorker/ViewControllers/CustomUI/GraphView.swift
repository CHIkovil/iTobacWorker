//
//  GraphView.swift
//  iTobacWorker
//
//  Created by Nikolas on 27.12.2021.
//

import Foundation
import UIKit

//MARK: CONSTANTS
private enum GraphViewConstants {
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 60
    static let bottomBorder: CGFloat = 50
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 10.0
}

final class GraphView: UIView {
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    func animateGraph(gPoints: [Int], color: UIColor, isAnimate: Bool) {
        self.maxValue = gPoints.max()
        if (maxValue == nil){return}
        self.gPoints = gPoints
        self.gColor = color
     
        let lines = drawGraphLines()
        self.layer.addSublayer(lines)
        
        let points = drawGraphPoints()
        for point in points {
            self.layer.addSublayer(point)
        }
      
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    private var maxValue: Int?
    private var gPoints: [Int]?
    private var gColor: UIColor?
   
    //MARK: SUPPORT FUNC
    private func makeUI(){
        let color = #colorLiteral(red: 0.1428617537, green: 0.1428931057, blue: 0.142857641, alpha: 1)
        self.layer.drawBlockLayer(cornerWidth: 25, color: color)
        
        let markup = drawHorizontalMarkup()
        self.layer.addSublayer(markup)
    }
    
    private func drawGraphLines() -> CAShapeLayer{
        let gPoints = self.gPoints!
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: calculateX(0), y: calculateY(gPoints[0])))
        
        for i in 1..<gPoints.count{
            let nextPoint = CGPoint(x: calculateX(i), y: calculateY(gPoints[i]))
            linePath.addLine(to: nextPoint)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = self.gColor!.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineCap = .round
        return shapeLayer
    }
    
    private func drawGraphPoints() -> [CAShapeLayer]{
        let gPoints = self.gPoints!
        var result:[CAShapeLayer] = []
        for i in 0..<gPoints.count {
            var point = CGPoint(x: calculateX(i), y: calculateY(gPoints[i]))
            point.x -= GraphViewConstants.circleDiameter / 2
            point.y -= GraphViewConstants.circleDiameter / 2
            
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: GraphViewConstants.circleDiameter, height: GraphViewConstants.circleDiameter)))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = self.gColor!.cgColor
            result.append(shapeLayer)
        }
        return result
    }
    
    private func drawHorizontalMarkup() -> CAShapeLayer{
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x:GraphViewConstants.margin, y: GraphViewConstants.topBorder))
        linePath.addLine(to: CGPoint(x: viewWidth - GraphViewConstants.margin, y: GraphViewConstants.topBorder))
        
        linePath.move(to: CGPoint(x: GraphViewConstants.margin, y: viewHeight / 2))
        linePath.addLine(to: CGPoint(x: viewWidth - GraphViewConstants.margin, y: viewHeight / 2))
        
        linePath.move(to: CGPoint(x: GraphViewConstants.margin, y: viewHeight - GraphViewConstants.bottomBorder))
        linePath.addLine(to: CGPoint(x: viewWidth - GraphViewConstants.margin, y: viewHeight - GraphViewConstants.bottomBorder))
        
        let color = UIColor(white: 1.0, alpha: GraphViewConstants.colorAlpha)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }
    
    private func calculateX(_ column: Int) -> CGFloat{
        let margin = GraphViewConstants.margin
        let graphWidth = viewWidth - margin * 2 - 4
        let spacing = graphWidth / CGFloat(6)
        
        return CGFloat(column) * spacing + margin + 2
    }
    
    private func calculateY(_ graphPoint: Int) -> CGFloat {
        let topBorder = GraphViewConstants.topBorder
        let bottomBorder = GraphViewConstants.bottomBorder
        let graphHeight = viewHeight - topBorder - bottomBorder
        
        
        let yPoint =  CGFloat(graphPoint) / CGFloat(self.maxValue!) * graphHeight
        
        return graphHeight + topBorder - yPoint
    }
}
