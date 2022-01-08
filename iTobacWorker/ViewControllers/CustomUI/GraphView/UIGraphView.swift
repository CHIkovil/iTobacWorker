//
//  UIGraphView.swift
//  iTobacWorker
//
//  Created by Nikolas on 27.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

private enum UIGraphViewString: String{
    case markupLayerName = "markup"
    case pointAnimationKey = "transform.scale"
}

//MARK: CONSTANTS

private enum UIGraphViewConstants {
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 45
    static let bottomBorder: CGFloat = 35
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 8.0
    static let defTextSize: CGFloat = 15
}

final class UIGraphView: UIView {
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: reloadGraph
    func reloadGraph(_ setup: GraphSetup, isAnimate: Bool){
        if (!checkGraphsMaxValue([setup])) {return}
        if (!checkGraphExist(setup)) {return}
        
        removeGraphs(annotations: [setup.annotation])
        addGraph(setup)
    }
    
    //MARK: showGraphs
    func showGraphs(_ setups: [GraphSetup], isAnimate: Bool) {
        if (setups.isEmpty) {return}
        if (!checkGraphsMaxValue(setups)) {return}
    
        let annotation = setups.map {$0.annotation}
        removeGraphs(annotations: annotation)
        for setup in setups {
            addGraph(setup)
        }
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.height}
    private var viewHeight: CGFloat {self.frame.height}
    private var maxValue: Int?
    
    //MARK: UI
    private lazy var minValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - UIGraphViewConstants.margin + 2, y: viewHeight - UIGraphViewConstants.bottomBorder - viewHeight * 0.05, width: viewHeight * 0.1, height: viewHeight * 0.1))
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: UIGraphViewConstants.defTextSize)
        label.backgroundColor = .clear
        label.textColor = .lightGray
        label.text = "\(0)"
        return label
    }()
    
    private lazy var maxValueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: viewWidth - UIGraphViewConstants.margin + 2, y: UIGraphViewConstants.topBorder - viewHeight * 0.05, width: viewHeight * 0.1, height: viewHeight * 0.1))
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: UIGraphViewConstants.defTextSize)
        label.backgroundColor = .clear
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var weekStackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: UIGraphViewConstants.margin, y: viewHeight - UIGraphViewConstants.bottomBorder, width: viewWidth - 2 * UIGraphViewConstants.margin, height: viewHeight * 0.1))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var annotationStackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: UIGraphViewConstants.margin, y: UIGraphViewConstants.topBorder - viewHeight * 0.1 - 10, width: viewWidth - 2 * UIGraphViewConstants.margin, height: viewHeight * 0.1))
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        self.layer.drawBlockLayer(cornerWidth: 25, color: #colorLiteral(red: 0.1582991481, green: 0.1590825021, blue: 0.1307061911, alpha: 1))
        
        self.addSubview(minValueLabel)
        self.addSubview(maxValueLabel)
        self.addSubview(weekStackView)
        self.addSubview(annotationStackView)
        
        showWeekdays()
        showMarkup()
    }
    
    private func addGraph(_ setup: GraphSetup){
        var graph: Graph!
        var finalSetup = setup
        
        if (finalSetup.viewSetup == nil) {
            finalSetup.viewSetup = ViewSetup(width: self.viewWidth, height: self.viewHeight, graphMaxValue: self.maxValue!)
        }
        
        let workItem = DispatchWorkItem {[weak self] in
            guard let self = self else{return}
            graph = self.drawGraph(finalSetup)
        }
        
        DispatchQueue.global(qos: .userInteractive).async(execute: workItem)
    
        workItem.notify(queue: .main) {
            
            graph.line.addActivationAnimation()
            
            self.layer.addSublayer(graph.line)
            
            self.layer.addSublayer(graph.clipping)
            for (index,point) in graph.points.enumerated() {
                point.addStickAnimation(duration: CGFloat(index + 1) / 10 + 0.1)
                self.layer.addSublayer(point)
            }
            
            self.getGraphAnnotation(setup) { annotation in
                self.annotationStackView.addArrangedSubview(annotation)
            }
        }
    }
    
    private func getGraphAnnotation(_ setup: GraphSetup, callback: @escaping(UILabel) -> Void) {
        let label = UILabel()
        let width = (self.viewWidth - 2 * UIGraphViewConstants.margin) / 2
        label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: UIGraphViewConstants.defTextSize - 2)
        label.textColor = .lightGray
        label.text = setup.annotation
        
        drawAnnotationLine(to: width, color: setup.color) { line in
            line.addActivationAnimation()
            label.layer.addSublayer(line)
        }
        
        callback(label)
    }
    
    private func showMarkup(){
        self.layer.sublayers?.forEach {
            if ($0.name == UIGraphViewString.markupLayerName.rawValue){
                $0.removeFromSuperlayer()
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
            label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: (viewWidth - 2 * UIGraphViewConstants.margin) / 7).isActive = true
            label.textAlignment = .center
            label.font = UIFont(name: GlobalString.fontName.rawValue, size: UIGraphViewConstants.defTextSize - 2)
            label.textColor = .lightGray
            label.text = weekday
            weekStackView.addArrangedSubview(label)
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
    
    private func checkGraphExist(_ setup: GraphSetup) -> Bool{
        let layers = self.layer.sublayers?.filter {$0.name == setup.annotation}
        
        switch layers {
        case (let layers?):
            if(!layers.isEmpty){
                return true
            }else{
                fallthrough
            }
        default:
            return false
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

    private func calculateX(_ column: Int,_ setup: GraphSetup?) -> CGFloat{
        let margin = UIGraphViewConstants.margin
        let graphWidth = (setup?.viewSetup?.width ?? self.viewWidth) - margin * 2 - 10
        let spacing = graphWidth / CGFloat(6)
        
        return CGFloat(column) * spacing + margin + 5
    }
    
    private func calculateY(_ graphPoint: Int, _ setup: GraphSetup) -> CGFloat {
        let topBorder = UIGraphViewConstants.topBorder
        let bottomBorder = UIGraphViewConstants.bottomBorder
        let graphHeight = setup.viewSetup!.height - topBorder - bottomBorder
        
        let yPoint =  CGFloat(graphPoint) / CGFloat(setup.viewSetup!.graphMaxValue) * graphHeight
        
        return graphHeight + topBorder - yPoint
    }
    
    //MARK: DRAW
    
    private func drawHorizontalMarkup(callback: @escaping(CAShapeLayer) -> Void) {
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x:UIGraphViewConstants.margin, y: UIGraphViewConstants.topBorder))
        linePath.addLine(to: CGPoint(x: viewWidth - UIGraphViewConstants.margin, y: UIGraphViewConstants.topBorder))
        
        linePath.move(to: CGPoint(x: UIGraphViewConstants.margin, y: viewHeight / 2))
        linePath.addLine(to: CGPoint(x: viewWidth - UIGraphViewConstants.margin, y: viewHeight / 2))
        
        linePath.move(to: CGPoint(x: UIGraphViewConstants.margin, y: viewHeight - UIGraphViewConstants.bottomBorder))
        linePath.addLine(to: CGPoint(x: viewWidth - UIGraphViewConstants.margin, y: viewHeight - UIGraphViewConstants.bottomBorder))
        
        let color = UIColor(white: 1.0, alpha: UIGraphViewConstants.colorAlpha)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.name = UIGraphViewString.markupLayerName.rawValue
        
        callback(shapeLayer)
    }
    
    private func drawVerticalMarkup(callback: @escaping(CAShapeLayer) -> Void) {
        let linePath = UIBezierPath()
        
        for column in 0...6{
            linePath.move(to: CGPoint(x: calculateX(column, nil), y: viewHeight - UIGraphViewConstants.bottomBorder))
            linePath.addLine(to: CGPoint(x: calculateX(column, nil), y: viewHeight - UIGraphViewConstants.bottomBorder - 5))
        }
        
        let color = UIColor(white: 1.0, alpha: UIGraphViewConstants.colorAlpha)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.name = UIGraphViewString.markupLayerName.rawValue
        
        callback(shapeLayer)
    }
    
    private func drawGraph(_ setup: GraphSetup) -> Graph {
        
        var pointLayers: [CAShapeLayer] = []
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: calculateX(0, setup), y: calculateY(setup.points[0], setup)))
        
        for i in 0..<setup.points.count{
            var nextPoint = CGPoint(x: calculateX(i,setup), y: calculateY(setup.points[i], setup))
            
            linePath.addLine(to: nextPoint)
            
            nextPoint.x -= UIGraphViewConstants.circleDiameter / 2
            nextPoint.y -= UIGraphViewConstants.circleDiameter / 2
            
            let pointPath = UIBezierPath(ovalIn: CGRect(origin: nextPoint, size: CGSize(width: UIGraphViewConstants.circleDiameter, height: UIGraphViewConstants.circleDiameter)))
            let pointLayer = CAShapeLayer()
            pointLayer.path = pointPath.cgPath
            pointLayer.fillColor = setup.color.cgColor
            pointLayer.name = setup.annotation
            pointLayers.append(pointLayer)
        }
        
        let linesLayer = CAShapeLayer()
        linesLayer.path = linePath.cgPath
        linesLayer.strokeColor = setup.color.cgColor
        linesLayer.fillColor = UIColor.clear.cgColor
        linesLayer.lineWidth = 3
        linesLayer.lineCap = .round
        linesLayer.name = setup.annotation
        
    
        let clippingLayer =  drawGraphClipping(setup, path: UIBezierPath(cgPath: linesLayer.path!))
        
        return  Graph(line: linesLayer, points: pointLayers, clipping: clippingLayer)
    }
    
    private func drawGraphClipping(_ setup: GraphSetup, path: UIBezierPath) -> CAShapeLayer {
        let clippingPath = path.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: calculateX(6, setup),y: viewHeight - UIGraphViewConstants.bottomBorder - 5))
        clippingPath.addLine(to: CGPoint(x: calculateX(0, setup), y: viewHeight - UIGraphViewConstants.bottomBorder - 5))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = clippingPath.cgPath
        shapeLayer.fillColor = setup.color.cgColor
        shapeLayer.opacity = 0.3
        shapeLayer.name = setup.annotation
        
        return shapeLayer
    }
    
    private func drawAnnotationLine(to x: CGFloat,color: UIColor, callback: @escaping(CAShapeLayer) -> Void){
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: 20, y: self.annotationStackView.frame.height))
        linePath.addLine(to: CGPoint(x: x - 20, y: self.annotationStackView.frame.height))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = .round
        callback(shapeLayer)
    }
}

//MARK: ANIMATION EXTENSION

private extension CALayer {
    func addStickAnimation(duration: CGFloat){
        let animation = CABasicAnimation(keyPath: UIGraphViewString.pointAnimationKey.rawValue)
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        self.add(animation, forKey: UIGraphViewString.pointAnimationKey.rawValue)
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


