//
//  GraphView.swift
//  iTobacWorker
//
//  Created by Nikolas on 27.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

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
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers?.removeAll()
        makeUI()
    }
    
    //MARK: showGraphs
    func showGraphs(_ setups: [GraphSetup], isAnimate: Bool) {
        guard let maxValue = getGraphsMaxValue(setups) else {return}
        self.maxValueLabel.text = "\(maxValue)"
    
        for setup in setups {
            showGraph(setup, maxValue: maxValue) {graph in
                self.layer.addSublayer(graph.lines)
                self.layer.addSublayer(graph.clipping)
                for point in graph.points {
                    self.layer.addSublayer(point)
                }
            }
        }
        showGraphAnnotations(setups)
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    //MARK: UI
    private lazy var minValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - GraphViewConstants.margin + 2, y: viewHeight - GraphViewConstants.bottomBorder - viewHeight * 0.05, width: viewHeight * 0.1, height: viewHeight * 0.1))
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: GraphViewConstants.defTextSize)
        label.backgroundColor = .clear
        label.textColor = .lightGray
        label.text = "\(0)"
        return label
    }()
    
    private lazy var maxValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - GraphViewConstants.margin + 2, y: GraphViewConstants.topBorder - viewHeight * 0.05, width: viewHeight * 0.1, height: viewHeight * 0.1))
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: GraphViewConstants.defTextSize)
        label.backgroundColor = .clear
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var weekStackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: GraphViewConstants.margin, y: viewHeight - GraphViewConstants.bottomBorder, width: viewWidth - 2 * GraphViewConstants.margin, height: viewHeight * 0.1))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var annotationStackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: GraphViewConstants.margin, y: GraphViewConstants.topBorder - viewHeight * 0.1 - 10, width: viewWidth - 2 * GraphViewConstants.margin, height: viewHeight * 0.1))
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
        self.addSubview(annotationStackView)
        
        showWeekdays()
        drawMarkup()
    }
    
    private func drawMarkup(){
        drawHorizontalMarkup { markup in
            self.layer.addSublayer(markup)
        }
        
        drawVerticalMarkup{ markup in
            self.layer.addSublayer(markup)
        }
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
    
    private func drawVerticalMarkup(callback: @escaping(CAShapeLayer) -> Void) {
        let linePath = UIBezierPath()
    
        for column in 0...6{
            linePath.move(to: CGPoint(x: calculateX(column), y: viewHeight - GraphViewConstants.bottomBorder))
            linePath.addLine(to: CGPoint(x: calculateX(column), y: viewHeight - GraphViewConstants.bottomBorder - 5))
        }
        
        let color = UIColor(white: 1.0, alpha: GraphViewConstants.colorAlpha)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        
        callback(shapeLayer)
    }
    
    private func showWeekdays(){
        self.weekStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        let weekdays = dateFormatter.shortWeekdaySymbols.shift()
        for weekday in weekdays {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: (viewWidth - 2 * GraphViewConstants.margin) / 7).isActive = true
            label.textAlignment = .center
            label.font = UIFont(name: GlobalString.fontName.rawValue, size: GraphViewConstants.defTextSize - 2)
            label.textColor = .lightGray
            label.text = weekday
            weekStackView.addArrangedSubview(label)
        }
    }
    
    private func showGraphAnnotations(_ setups: [GraphSetup]){
        self.annotationStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        for setup in setups {
            let label = UILabel()
            let labelWidth = (viewWidth - 2 * GraphViewConstants.margin) / CGFloat(setups.count)
         
            label.translatesAutoresizingMaskIntoConstraints = false
            label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            label.textAlignment = .center
            label.font = UIFont(name: GlobalString.fontName.rawValue, size: GraphViewConstants.defTextSize - 2)
            label.textColor = .lightGray
            label.text = setup.annotation
            
            drawAnnotationLine(labelWidth: labelWidth, color: setup.color) { line in
                label.layer.addSublayer(line)
            }
            
            annotationStackView.addArrangedSubview(label)
        }
    }
    
    private func drawAnnotationLine(labelWidth: CGFloat, color: UIColor, callback: @escaping(CAShapeLayer) -> Void){
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: 20, y: annotationStackView.frame.height))
        linePath.addLine(to: CGPoint(x: labelWidth - 20, y: annotationStackView.frame.height))
        
        let line = CAShapeLayer()
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 4
        line.lineCap = .round
        callback(line)
    }
    
    private func showGraph(_ setup: GraphSetup, maxValue: Int, callback: @escaping(Graph) -> Void){
        let lines = drawGraphLines(setup, maxValue: maxValue)
        let clipping = drawGraphClipping(UIBezierPath(cgPath: lines.path!), color: setup.color)
        let points = drawGraphPoints(setup, maxValue: maxValue)
        
        callback(Graph(lines: lines, clipping: clipping, points: points))
    }
    
    private func drawGraphLines(_ setup: GraphSetup, maxValue: Int) -> CAShapeLayer{
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: calculateX(0), y: calculateY(setup.points[0],maxValue)))
        for i in 0..<setup.points.count{
            let nextPoint = CGPoint(x: calculateX(i), y: calculateY(setup.points[i], maxValue))
            linePath.addLine(to: nextPoint)
        }
        
        let lines = CAShapeLayer()
        lines.path = linePath.cgPath
        lines.strokeColor = setup.color.cgColor
        lines.fillColor = UIColor.clear.cgColor
        lines.lineWidth = 3
        lines.lineCap = .round
        return lines
    }
    
    private func drawGraphClipping(_ path: UIBezierPath, color: UIColor) -> CAShapeLayer{
        let clippingPath = path.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: calculateX(6),y: viewHeight - GraphViewConstants.bottomBorder - 5))
        clippingPath.addLine(to: CGPoint(x: calculateX(0), y: viewHeight - GraphViewConstants.bottomBorder - 5))
        
        let clipping = CAShapeLayer()
        clipping.path = clippingPath.cgPath
        clipping.fillColor = color.cgColor
        clipping.opacity = 0.3
        return clipping
    }
    
    private func drawGraphPoints(_ setup: GraphSetup, maxValue: Int) -> [CAShapeLayer]{
        var gPoints:[CAShapeLayer] = []
        for i in 0..<setup.points.count {
            var point = CGPoint(x: calculateX(i), y: calculateY(setup.points[i], maxValue))
            point.x -= GraphViewConstants.circleDiameter / 2
            point.y -= GraphViewConstants.circleDiameter / 2
            
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: GraphViewConstants.circleDiameter, height: GraphViewConstants.circleDiameter)))
            
            let gPoint = CAShapeLayer()
            gPoint.path = circlePath.cgPath
            gPoint.fillColor = setup.color.cgColor
            gPoints.append(gPoint)
        }
        
        return gPoints
    }
    
    private func getGraphsMaxValue(_ setups: [GraphSetup]) -> Int?{
        var allMaxValue:[Int] = []
        for setup in setups {
            guard let maxValue = setup.points.max() else{continue}
            allMaxValue.append(maxValue)
        }
        
        guard let maxValue = allMaxValue.max() else{return nil}
        return maxValue
    }
    
    private func calculateX(_ column: Int) -> CGFloat{
        let margin = GraphViewConstants.margin
        let graphWidth = viewWidth - margin * 2 - 10
        let spacing = graphWidth / CGFloat(6)
        
        return CGFloat(column) * spacing + margin + 5
    }
    
    private func calculateY(_ graphPoint: Int , _ maxValue: Int) -> CGFloat {
        let topBorder = GraphViewConstants.topBorder
        let bottomBorder = GraphViewConstants.bottomBorder
        let graphHeight = viewHeight - topBorder - bottomBorder
        
        
        let yPoint =  CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
        
        return graphHeight + topBorder - yPoint
    }
}

//MARK: ANIMATION EXTENSION



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

