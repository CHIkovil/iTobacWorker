//
//  WorkTabBar.swift
//  iTobacWorker
//
//  Created by Nikolas on 02.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

private enum WorkTabBarString: String {
    case infoImageName = "info"
    case searchImageName = "search"
    case progressImageName = "progress"
    case frameLayerName = "frame"
}

//MARK: CONSTANTS

private enum WorkTabBarConstants{
    static let middleButtonDiameter: CGFloat = 70
    static let otherButtonDiameter: CGFloat = 60
    static let circleRadius: CGFloat = 43
}

final class WorkTabBar: UITabBar{
    
    override func draw(_ rect: CGRect) {
        makeUI()
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
    
    //MARK: selectItem
    func selectItem(at item: Int){
        deselectItems()
        switch item{
        case 0:
            self.infoButton.animateSelect()
        case 1:
            self.searchButton.animateSelect()
        case 2:
            self.progressButton.animateSelect()
        default:break
        }
    }
    
    //MARK:  UI
    
    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: WorkTabBarString.infoImageName.rawValue), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        button.layer.cornerRadius = WorkTabBarConstants.otherButtonDiameter / 2
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: WorkTabBarString.searchImageName.rawValue), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        button.layer.cornerRadius = WorkTabBarConstants.middleButtonDiameter / 2
        button.layer.borderWidth = 4
        button.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        return button
    }()
    

    lazy var progressButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: WorkTabBarString.progressImageName.rawValue), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        button.layer.cornerRadius = WorkTabBarConstants.otherButtonDiameter / 2
        button.layer.borderWidth = 3
        button.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        return button
    }()
    
    //MARK: PRIVATE
    private var tabBarWidth: CGFloat {self.bounds.width}
    private var tabBarHeight: CGFloat {self.bounds.height}
    private var buttonStep: CGFloat {self.bounds.width / 4}
    
    //MARK: CONSTRAINTS
    
    private func constraintsInfoButton(){
        infoButton.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(WorkTabBarConstants.otherButtonDiameter)
            make.height.equalTo(WorkTabBarConstants.otherButtonDiameter)
            make.centerX.equalTo(buttonStep)
            make.centerY.equalTo(tabBarHeight / 2)
        }
    }
    
    private func constraintsSearchButton(){
        searchButton.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(WorkTabBarConstants.middleButtonDiameter)
            make.height.equalTo(WorkTabBarConstants.middleButtonDiameter)
            make.centerX.equalTo(buttonStep * 2)
            make.centerY.equalTo(tabBarHeight / 2).offset(20)
        }
    }
    
    private func constraintsProgressButton(){
        progressButton.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(WorkTabBarConstants.otherButtonDiameter)
            make.height.equalTo(WorkTabBarConstants.otherButtonDiameter)
            make.centerX.equalTo(buttonStep * 3)
            make.centerY.equalTo(tabBarHeight / 2)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        self.addSubview(searchButton)
        self.addSubview(infoButton)
        self.addSubview(progressButton)
        
        constraintsSearchButton()
        constraintsInfoButton()
        constraintsProgressButton()
        
        showFrame()
    }
    
    private func showFrame(){
        if let layers = self.layer.sublayers?.filter({$0.name == WorkTabBarString.frameLayerName.rawValue}) {
            if (!layers.isEmpty){
                return
            }
        }
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        
        drawFrameLayer() {shapeLayer in
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
       
        drawCircleLayer() { shapeLayer in
            self.layer.insertSublayer(shapeLayer, at: 1)
        }
        
    }
    
    private func drawFrameLayer(callback: @escaping(CAShapeLayer) -> Void){
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 35, height: 0.0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1).cgColor
        shapeLayer.name =  WorkTabBarString.frameLayerName.rawValue
        callback(shapeLayer)
    }
    
    private func drawCircleLayer(callback: @escaping(CAShapeLayer) -> Void) {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: buttonStep * 2, y: 20),
                    radius: WorkTabBarConstants.circleRadius,
                    startAngle: 180 * .pi / 180,
                    endAngle: 0 * 180 / .pi,
                    clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1).cgColor
        shapeLayer.name =  WorkTabBarString.frameLayerName.rawValue
        callback(shapeLayer)
    }
    
    private func deselectItems(){
        for button in self.subviews{
            button.animateDeselect()
        }
    }
}

//MARK: ANIMATION EXTENSION

private extension UIView{
    func animateSelect(){
        UIView.animate(withDuration: 0.2,
                       animations: {[weak self] in
            guard let self = self else{return}
            self.layer.borderColor = #colorLiteral(red: 0.8736050725, green: 0.8737519383, blue: 0.8735856414, alpha: 1).cgColor
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        },
                       completion: {  _ in
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self = self else{return}
                self.transform = CGAffineTransform.identity
            }
        })
    }
    
    func animateDeselect(){
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self = self else{return}
            self.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1).cgColor
        }
    }
}
