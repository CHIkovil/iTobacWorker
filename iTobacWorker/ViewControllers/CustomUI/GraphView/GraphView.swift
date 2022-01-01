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
    func showGraphs(_ graphs: [Graph], isAnimate: Bool) {
        var allMaxValue:[Int] = []
        for graph in graphs {
            guard let maxValue = graph.points.max() else{continue}
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
        
        for graph in graphs {
            let lines = drawGraphLines(graph, maxValue: maxValue)
            self.layer.addSublayer(lines)
            
            let points = drawGraphPoints(graph, maxValue: maxValue)
            for point in points {
                self.layer.addSublayer(point)
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
        let markup = drawHorizontalMarkup()
        self.layer.addSublayer(markup)
        
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
    
    private func drawGraphLines(_ graph: Graph, maxValue: Int) -> CAShapeLayer{
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: calculateX(0), y: calculateY(graph.points[0],maxValue)))
        
        for i in 1..<graph.points.count{
            let nextPoint = CGPoint(x: calculateX(i), y: calculateY(graph.points[i], maxValue))
            linePath.addLine(to: nextPoint)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = graph.color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.name = GraphViewString.graphLayerName.rawValue
        return shapeLayer
    }
    
    private func drawGraphPoints(_ graph: Graph, maxValue: Int) -> [CAShapeLayer]{
        var result:[CAShapeLayer] = []
        for i in 0..<graph.points.count {
            var point = CGPoint(x: calculateX(i), y: calculateY(graph.points[i], maxValue))
            point.x -= GraphViewConstants.circleDiameter / 2
            point.y -= GraphViewConstants.circleDiameter / 2
            
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: GraphViewConstants.circleDiameter, height: GraphViewConstants.circleDiameter)))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = graph.color.cgColor
            shapeLayer.name = GraphViewString.graphLayerName.rawValue
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

