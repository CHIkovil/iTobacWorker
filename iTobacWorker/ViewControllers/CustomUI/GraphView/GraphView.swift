//
//  GraphView.swift
//  iTobacWorker
//
//  Created by Nikolas on 27.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

private enum GraphViewString: String {
    case graphLayerName = "graph"
}

//MARK: CONSTANTS
private enum GraphViewConstants {
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 45
    static let bottomBorder: CGFloat = 35
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 8.0
    static let defTextSize: CGFloat = 15
}

final class GraphView: UIView {
    var textSize: CGFloat?
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: showGraphs
    func showGraphs(_ setups: [GraphSetup], isAnimate: Bool) {
        var allMaxValue:[Int] = []
        for setup in setups {
            guard let maxValue = setup.points.max() else{continue}
            allMaxValue.append(maxValue)
        }
        
        guard let maxValue = allMaxValue.max() else{return}
        self.maxValueLabel.text = "\(maxValue)"
        
        self.layer.sublayers?.forEach {
            guard let name = $0.name else{return}
            if (name.starts(with: GraphViewString.graphLayerName.rawValue)){
                $0.removeFromSuperlayer()
            }
        }
        
        for setup in setups {
            drawGraphLines(setup, maxValue: maxValue) {graph in
                self.layer.addSublayer(graph.lines)
                self.layer.addSublayer(graph.clipping)
            }
            
            drawGraphPoints(setup, maxValue: maxValue) {points in
                for point in points {
                    self.layer.addSublayer(point)
                }
            }
       
        }
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    //MARK: UI
    private lazy var minValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - GraphViewConstants.margin + 2, y: viewHeight - GraphViewConstants.bottomBorder - viewHeight * 0.05, width: viewHeight * 0.1, height: viewHeight * 0.1))
        label.backgroundColor = .clear
        label.textColor = .lightGray
        label.text = "\(0)"
        return label
    }()
    
    private lazy var maxValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - GraphViewConstants.margin + 2, y: GraphViewConstants.topBorder - viewHeight * 0.05, width: viewHeight * 0.1, height: viewHeight * 0.1))
        label.backgroundColor = .clear
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var weekStackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: GraphViewConstants.margin, y: viewHeight - GraphViewConstants.bottomBorder, width: viewWidth - 2 * GraphViewConstants.margin, height: viewHeight * 0.1))
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        let color = #colorLiteral(red: 0.1582991481, green: 0.1590825021, blue: 0.1307061911, alpha: 1)
        self.layer.drawBlockLayer(cornerWidth: 25, color: color)
        
        self.addSubview(minValueLabel)
        self.addSubview(maxValueLabel)
        self.addSubview(weekStackView)
        
        minValueLabel.font = UIFont(name: GlobalString.fontName.rawValue, size: textSize ?? GraphViewConstants.defTextSize)
        maxValueLabel.font = UIFont(name: GlobalString.fontName.rawValue, size: textSize ?? GraphViewConstants.defTextSize)
        
        setupGraphDisplay()
    }
    
    private func setupGraphDisplay(){
        drawHorizontalMarkup { markup in
            self.layer.addSublayer(markup)
        }
        
        let weekdays = DateFormatter().shortWeekdaySymbols.shift()
        for weekday in weekdays {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: (viewWidth - 2 * GraphViewConstants.margin) / 7).isActive = true
            label.textAlignment = .center
            label.font = UIFont(name: GlobalString.fontName.rawValue, size: textSize ?? GraphViewConstants.defTextSize)
            label.textColor = .lightGray
            label.text = weekday
            weekStackView.addArrangedSubview(label)
        }
    }
    
    private func drawGraphLines(_ setup: GraphSetup, maxValue: Int, callback: @escaping(Graph) -> Void){
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: calculateX(0), y: calculateY(setup.points[0],maxValue)))
        
        for i in 1..<setup.points.count{
            let nextPoint = CGPoint(x: calculateX(i), y: calculateY(setup.points[i], maxValue))
            linePath.addLine(to: nextPoint)
        }
        
        let lines = CAShapeLayer()
        lines.path = linePath.cgPath
        lines.strokeColor = setup.color.cgColor
        lines.fillColor = UIColor.clear.cgColor
        lines.lineWidth = 3
        lines.lineCap = .round
        lines.name = GraphViewString.graphLayerName.rawValue
        
        let clipping = drawGraphClipping(linePath, color: setup.color)
        
        callback(Graph(lines: lines, clipping: clipping))
    }
    
    private func drawGraphClipping(_ path: UIBezierPath, color: UIColor) -> CAShapeLayer{
        let clippingPath = path.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: calculateX(6),y: viewHeight - GraphViewConstants.bottomBorder))
        clippingPath.addLine(to: CGPoint(x: calculateX(0), y: viewHeight - GraphViewConstants.bottomBorder))
        clippingPath.addClip()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = clippingPath.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.name = GraphViewString.graphLayerName.rawValue
        shapeLayer.opacity = 0.3
        
        return shapeLayer
    }
    
    private func drawGraphPoints(_ setup: GraphSetup, maxValue: Int, callback: @escaping([CAShapeLayer]) -> Void) {
        var pointLayers:[CAShapeLayer] = []
        for i in 0..<setup.points.count {
            var point = CGPoint(x: calculateX(i), y: calculateY(setup.points[i], maxValue))
            point.x -= GraphViewConstants.circleDiameter / 2
            point.y -= GraphViewConstants.circleDiameter / 2
            
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: GraphViewConstants.circleDiameter, height: GraphViewConstants.circleDiameter)))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = setup.color.cgColor
            shapeLayer.name = GraphViewString.graphLayerName.rawValue
            pointLayers.append(shapeLayer)
        }
        
        callback(pointLayers)
    }
    
    private func drawHorizontalMarkup(callback: @escaping(CAShapeLayer) -> Void) {
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
        callback(shapeLayer)
    }
    
    private func calculateX(_ column: Int) -> CGFloat{
        let margin = GraphViewConstants.margin
        let graphWidth = viewWidth - margin * 2 - 4
        let spacing = graphWidth / CGFloat(6)
        
        return CGFloat(column) * spacing + margin + 2
    }
    
    private func calculateY(_ graphPoint: Int , _ maxValue: Int) -> CGFloat {
        let topBorder = GraphViewConstants.topBorder
        let bottomBorder = GraphViewConstants.bottomBorder
        let graphHeight = viewHeight - topBorder - bottomBorder
        
        
        let yPoint =  CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
        
        return graphHeight + topBorder - yPoint
    }
}

//MARK: EXTENSION

private extension Array {
    func shift(withDistance distance: Int = 1) -> Array<Element> {
         let offsetIndex = distance >= 0 ?
             self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
             self.index(endIndex, offsetBy: distance, limitedBy: startIndex)

         guard let index = offsetIndex else { return self }
         return Array(self[index ..< endIndex] + self[startIndex ..< index])
     }
}

