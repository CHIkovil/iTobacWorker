//
//  GraphView.swift
//  iTobacWorker
//
//  Created by Nikolas on 27.12.2021.
//

import Foundation
import UIKit

//MARK: STRING
private enum GraphViewString: String{
    case markupLayerName = "markup"
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
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: reloadGraph
    func reloadGraph(_ setup: GraphSetup, isAnimate: Bool){
        if (!checkGraphsMaxValue([setup])) {return}
        if (self.annotationWidth == nil) {return}
        removeGraphs(annotations: [setup.annotation])
        addGraph(setup, isAnimate: isAnimate)
    }
    
    //MARK: showGraphs
    func showGraphs(_ setups: [GraphSetup], isAnimate: Bool) {
        if (setups.isEmpty) {return}
        if (!checkGraphsMaxValue(setups)) {return}
        self.annotationWidth = (self.viewWidth - 2 * GraphViewConstants.margin) / CGFloat(setups.count)
        
        let annotations = setups.map {$0.annotation}
        removeGraphs(annotations: annotations)
        
        for setup in setups {
            addGraph(setup, isAnimate: isAnimate)
        }
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    private var maxValue: Int!
    private var annotationWidth: CGFloat!
    
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
        showMarkup()
    }
    
    private func showMarkup(){
        if let markupLayers = self.layer.sublayers?.filter({$0.name == GraphViewString.markupLayerName.rawValue}) {
            if (!markupLayers.isEmpty){
                return
            }
        }
        
        drawHorizontalMarkup { markup in
            self.layer.addSublayer(markup)
        }
     
        drawVerticalMarkup{ markup in
            self.layer.addSublayer(markup)
        }
       
    }
    
    private func showWeekdays(){
        if (!self.weekStackView.arrangedSubviews.isEmpty){return}
        
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
    
    private func addGraphAnnotation(_ setup: GraphSetup, isAnimate: Bool){
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: self.annotationWidth).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: GraphViewConstants.defTextSize - 2)
        label.textColor = .lightGray
        label.text = setup.annotation
        
        drawAnnotationLine(color: setup.color) { line in
            label.layer.addSublayer(line)
        }
        
        annotationStackView.addArrangedSubview(label)
    }
    
    private func addGraph(_ setup: GraphSetup, isAnimate: Bool){
        addGraphAnnotation(setup, isAnimate: isAnimate)
        
        let lines = drawGraphLines(setup)
        let points = drawGraphPoints(setup)
        let clipping = drawGraphClipping(setup, path: UIBezierPath(cgPath: lines.path!))
        
        self.layer.addSublayer(lines)
        self.layer.addSublayer(clipping)
        for point in points {
            self.layer.addSublayer(point)
        }
    }
    
    private func removeGraphs(annotations: [String]) {
        
        self.layer.sublayers?.forEach {layer in
            guard let name = layer.name else{return}
            if (annotations.contains(name)){
                layer.removeFromSuperlayer()
            }
        }
        
        self.annotationStackView.arrangedSubviews.forEach {view in
            guard let label = view as? UILabel else{return}
            guard let name = label.text else{return}
            if (annotations.contains(name)) {
                view.removeFromSuperview()
            }
        }
        
    }
    
    private func checkGraphsMaxValue(_ setups: [GraphSetup]) -> Bool {
        if setups.count == 1{
            guard let newMaxValue = setups.first?.points.max() else{return false}
            switch self.maxValue{
            case (let maxValue?):
                if (newMaxValue > maxValue){
                    fallthrough
                }
            default:
                self.maxValue = newMaxValue
            }
        }else{
            var allMaxValue:[Int] = []
            for setup in setups {
                guard let maxValue = setup.points.max() else{continue}
                allMaxValue.append(maxValue)
            }
            guard let maxValue = allMaxValue.max() else{return false}
            self.maxValue = maxValue
        }
        
        self.maxValueLabel.text = "\(self.maxValue!)"
        return true
    }
    
    private func calculateX(_ column: Int) -> CGFloat{
        let margin = GraphViewConstants.margin
        let graphWidth = self.viewWidth - margin * 2 - 10
        let spacing = graphWidth / CGFloat(6)
        
        return CGFloat(column) * spacing + margin + 5
    }
    
    private func calculateY(_ graphPoint: Int) -> CGFloat {
        let topBorder = GraphViewConstants.topBorder
        let bottomBorder = GraphViewConstants.bottomBorder
        let graphHeight = self.viewHeight - topBorder - bottomBorder
        
        let yPoint =  CGFloat(graphPoint) / CGFloat(self.maxValue!) * graphHeight
        
        return graphHeight + topBorder - yPoint
    }
    
    //MARK: DRAW
    
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
        shapeLayer.name = GraphViewString.markupLayerName.rawValue
        
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
        shapeLayer.name = GraphViewString.markupLayerName.rawValue
        
        callback(shapeLayer)
    }
    
    private func drawGraphLines(_ setup: GraphSetup) -> CAShapeLayer{
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: calculateX(0), y: calculateY(setup.points[0])))
        for i in 0..<setup.points.count{
            let nextPoint = CGPoint(x: calculateX(i), y: calculateY(setup.points[i]))
            linePath.addLine(to: nextPoint)
        }
        
        let lines = CAShapeLayer()
        lines.path = linePath.cgPath
        lines.strokeColor = setup.color.cgColor
        lines.fillColor = UIColor.clear.cgColor
        lines.lineWidth = 3
        lines.lineCap = .round
        lines.name = setup.annotation
        return lines
    }
    
    private func drawGraphClipping(_ setup: GraphSetup,  path: UIBezierPath) -> CAShapeLayer{
        let clippingPath = path.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: calculateX(6),y: viewHeight - GraphViewConstants.bottomBorder - 5))
        clippingPath.addLine(to: CGPoint(x: calculateX(0), y: viewHeight - GraphViewConstants.bottomBorder - 5))
        
        let clipping = CAShapeLayer()
        clipping.path = clippingPath.cgPath
        clipping.fillColor = setup.color.cgColor
        clipping.opacity = 0.3
        clipping.name = setup.annotation
        return clipping
    }
    
    private func drawGraphPoints(_ setup: GraphSetup) -> [CAShapeLayer]{
        var gPoints:[CAShapeLayer] = []
        for i in 0..<setup.points.count {
            var point = CGPoint(x: calculateX(i), y: calculateY(setup.points[i]))
            point.x -= GraphViewConstants.circleDiameter / 2
            point.y -= GraphViewConstants.circleDiameter / 2
            
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: GraphViewConstants.circleDiameter, height: GraphViewConstants.circleDiameter)))
            
            let gPoint = CAShapeLayer()
            gPoint.path = circlePath.cgPath
            gPoint.fillColor = setup.color.cgColor
            gPoints.append(gPoint)
            gPoint.name = setup.annotation
        }
        
        return gPoints
    }
    
    private func drawAnnotationLine(color: UIColor, callback: @escaping(CAShapeLayer) -> Void){
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: 20, y: self.annotationStackView.frame.height))
        linePath.addLine(to: CGPoint(x: self.annotationWidth - 20, y: self.annotationStackView.frame.height))
        
        let line = CAShapeLayer()
        line.path = linePath.cgPath
        line.strokeColor = color.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 4
        line.lineCap = .round
        callback(line)
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

