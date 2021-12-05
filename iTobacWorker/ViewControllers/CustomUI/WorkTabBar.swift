//
//  WorkTabBar.swift
//  iTobacWorker
//
//  Created by Nikolas on 02.12.2021.
//

import Foundation
import UIKit

final class WorkTabBar: UITabBar{
    
    // MARK: draw
    override func draw(_ rect: CGRect) {
        drawTabBar()
    }
    
    //MARK: point
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let pointIsInside = super.point(inside: point, with: event)
        if pointIsInside == false {
            for subview in subviews {
                let pointInSubview = subview.convert(point, from: self)
                if subview.point(inside: pointInSubview, with: event) {
                    return true
                }
            }
        }
        return pointIsInside
    }
    
    //MARK: PRIVATE VAR
    
    private let middleButtonDiameter: CGFloat = 70
    private let otherButtonDiameter: CGFloat = 60
    private let circleRadius: CGFloat = 43
    
    private var tabBarWidth: CGFloat {self.bounds.width}
    private var tabBarHeight: CGFloat {self.bounds.height}
    private var buttonStep: CGFloat { self.bounds.width / 4}
    
    //MARK: PRIVATE UI
    
    
    
    //MARK: infoButton
    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "info"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        button.layer.cornerRadius = otherButtonDiameter / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        return button
    }()
    
    //MARK: searchButton
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        button.layer.cornerRadius = middleButtonDiameter / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        return button
    }()
    
    //MARK: progressButton
    lazy var progressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "progress"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        button.layer.cornerRadius = otherButtonDiameter / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        return button
    }()
}

//MARK: PRIVATE UI FUNC
extension WorkTabBar {
    
    
    //MARK: CONSTRAINTS
    
    
    
    //MARK: constraintsInfoButton
    func constraintsInfoButton(){
        infoButton.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(otherButtonDiameter)
            make.height.equalTo(otherButtonDiameter)
            make.centerX.equalTo(buttonStep)
            make.centerY.equalTo(tabBarHeight / 2)
        }
    }
    
    //MARK: constraintsSearchButton
    func constraintsSearchButton(){
        searchButton.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(middleButtonDiameter)
            make.height.equalTo(middleButtonDiameter)
            make.centerX.equalTo(buttonStep * 2)
            make.centerY.equalTo(tabBarHeight / 2).offset(20)
        }
    }
    
    //MARK: constraintsProgressButton
    func constraintsProgressButton(){
        progressButton.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(otherButtonDiameter)
            make.height.equalTo(otherButtonDiameter)
            make.centerX.equalTo(buttonStep * 3)
            make.centerY.equalTo(tabBarHeight / 2)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    
    
    // MARK: drawTabBar
    func drawTabBar() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        
        self.layer.insertSublayer(drawShapeLayer(), at: 0)
        self.layer.insertSublayer(drawCircleLayer(), at: 1)
        
        self.addSubview(searchButton)
        self.addSubview(infoButton)
        self.addSubview(progressButton)
        constraintsSearchButton()
        constraintsInfoButton()
        constraintsProgressButton()
    }
    
    //MARK: drawShapeLayer
    func drawShapeLayer() -> CAShapeLayer{
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 35, height: 0.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1).cgColor
        return shapeLayer
    }
    
    //MARK: drawCircleLayer
    func drawCircleLayer() -> CAShapeLayer {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: buttonStep * 2, y: 20),
                    radius: circleRadius,
                    startAngle: 180 * .pi / 180,
                    endAngle: 0 * 180 / .pi,
                    clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.fillColor = #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1).cgColor
        return circleLayer
    }
}
