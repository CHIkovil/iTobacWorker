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
    case pointAnimationKey = "transform.scale"
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
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    private var maxValue: Int!
    
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
    
    private func addGraph(_ setup: GraphSetup){
        showGraphLines(setup)
        showGraphPoints(setup)
        showGraphAnnotation(setup)
    }
    
    private func showGraphLines(_ setup: GraphSetup) {
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: calculateX(0), y: calculateY(setup.points[0])))
        for i in 0..<setup.points.count{
            let nextPoint = CGPoint(x: calculateX(i), y: calculateY(setup.points[i]))
            linePath.addLine(to: nextPoint)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = setup.color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.name = setup.annotation
        
        drawGraphClipping(setup, path: UIBezierPath(cgPath: shapeLayer.path!)) {shapeLayer in
            self.layer.addSublayer(shapeLayer)
        }
        
        shapeLayer.addActivationAnimation()
        self.layer.addSublayer(shapeLayer)
    }
    
    private func showGraphPoints(_ setup: GraphSetup) {
        for i in 0..<setup.points.count {
            var nextPoint = CGPoint(x: calculateX(i), y: calculateY(setup.points[i]))
            nextPoint.x -= GraphViewConstants.circleDiameter / 2
            nextPoint.y -= GraphViewConstants.circleDiameter / 2
            
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: nextPoint, size: CGSize(width: GraphViewConstants.circleDiameter, height: GraphViewConstants.circleDiameter)))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = setup.color.cgColor
            shapeLayer.name = setup.annotation
            
            shapeLayer.addStickAnimation(duration: CGFloat(i + 1) / 10 + 0.1)
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    private func showGraphAnnotation(_ setup: GraphSetup){
        let label = UILabel()
        let width = (self.viewWidth - 2 * GraphViewConstants.margin) / 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.textAlignment = .center
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: GraphViewConstants.defTextSize - 2)
        label.textColor = .lightGray
        label.text = setup.annotation
        
        drawAnnotationLine(to: width, color: setup.color) { line in
            line.addActivationAnimation()
            label.layer.addSublayer(line)
        }
        
        annotationStackView.addArrangedSubview(label)
    }
    
    private func showMarkup(){
        self.layer.sublayers?.forEach {
            if ($0.name == GraphViewString.markupLayerName.rawValue){
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
            label.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: (viewWidth - 2 * GraphViewConstants.margin) / 7).isActive = true
            label.textAlignment = .center
            label.font = UIFont(name: GlobalString.fontName.rawValue, size: GraphViewConstants.defTextSize - 2)
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
    
    private func drawGraphClipping(_ setup: GraphSetup, path: UIBezierPath, callback: @escaping(CAShapeLayer) -> Void){
        let clippingPath = path.copy() as! UIBezierPath
        
        clippingPath.addLine(to: CGPoint(x: calculateX(6),y: viewHeight - GraphViewConstants.bottomBorder - 5))
        clippingPath.addLine(to: CGPoint(x: calculateX(0), y: viewHeight - GraphViewConstants.bottomBorder - 5))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = clippingPath.cgPath
        shapeLayer.fillColor = setup.color.cgColor
        shapeLayer.opacity = 0.3
        shapeLayer.name = setup.annotation
        
        callback(shapeLayer)
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
        let animation = CABasicAnimation(keyPath: GraphViewString.pointAnimationKey.rawValue)
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        self.add(animation, forKey: GraphViewString.pointAnimationKey.rawValue)
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


