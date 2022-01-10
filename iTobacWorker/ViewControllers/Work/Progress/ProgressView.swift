//
//  ProgressView.swift
//  iTobacWorker
//
//  Created by Nikolas on 08.12.2021.
//

import Foundation
import UIKit


enum GraphType {
    case money
    case cigarette
}

//MARK: STRING

private enum ProgressViewString: String {
    case moneyBankImageName = "safe-box"
    case cigaretteBankImageName = "ashtray"
    case moneyGraphButtonImageName = "money"
    case cigaretteGraphButtonName = "cigarettes"
    case graphButtonCircleLayerName = "arc"
}

//MARK: CONSTANTS

private enum ProgressViewConstants {
    static let graphButtonDiameter: CGFloat = 35
    static let graphButtonArcRadius: CGFloat = 42
    static let graphViewWidth: CGFloat = 255
    static let graphViewHeight: CGFloat = 250
    static let bankPickerSide: CGFloat = 150
    static let userImageViewSide: CGFloat = 240
}

class ProgressView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    //MARK: UI
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 100)
        return scrollView
    }()
    
    lazy var userImageView: UIUserImageView = {
        let imageView = UIUserImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var moneyBankPicker: UIBankPicker = {
        let imageView = UIBankPicker()
        imageView.image = UIImage(named: ProgressViewString.moneyBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cigaretteBankPicker: UIBankPicker = {
        let imageView = UIBankPicker()
        imageView.image = UIImage(named: ProgressViewString.cigaretteBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var graphBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var moneyGraphView: UIGraphView = {
        let view = UIGraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var cigaretteGraphView: UIGraphView = {
        let view = UIGraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var moneyGraphButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ProgressViewString.moneyGraphButtonImageName.rawValue), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = ProgressViewConstants.graphButtonDiameter / 2
        button.alpha = 0
        button.isUserInteractionEnabled = false
        button.layer.borderColor = #colorLiteral(red: 0.6947862506, green: 0.4770120382, blue: 0.02306269109, alpha: 1)
        button.layer.borderWidth = 3
        return button
    }()
    
    lazy var cigaretteGraphButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ProgressViewString.cigaretteGraphButtonName.rawValue), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = ProgressViewConstants.graphButtonDiameter / 2
        button.alpha = 0
        button.isUserInteractionEnabled = false
        button.layer.borderColor = #colorLiteral(red: 0.6947862506, green: 0.4770120382, blue: 0.02306269109, alpha: 1)
        button.layer.borderWidth = 3
        return button
    }()
    
    //MARK: CONSTRAINTS
    
    func constraintsScrollView() {
        scrollView.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    func constraintsUserImageView() {
        userImageView.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(scrollView.snp.top).offset(20)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.height.equalTo(ProgressViewConstants.userImageViewSide)
            make.width.equalTo(ProgressViewConstants.userImageViewSide)
        }
    }
    
    func constraintsMoneyBankPicker() {
        moneyBankPicker.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.trailing.equalTo(scrollView.snp.centerX).offset(-5)
            make.height.equalTo(ProgressViewConstants.bankPickerSide)
            make.width.equalTo(ProgressViewConstants.bankPickerSide)
        }
    }
    
    func constraintsCigaretteBankPicker() {
        cigaretteBankPicker.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.leading.equalTo(scrollView.snp.centerX).offset(5)
            make.height.equalTo(ProgressViewConstants.bankPickerSide)
            make.width.equalTo(ProgressViewConstants.bankPickerSide)
        }
    }
    
    func constraintsGraphBackgroundView() {
        graphBackgroundView.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(moneyBankPicker.snp.bottom).offset(15)
            make.height.equalTo(ProgressViewConstants.graphViewHeight)
            make.width.equalTo(ProgressViewConstants.graphViewWidth + 90)
        }
    }
    
    func constraintsMoneyGraphView() {
        moneyGraphView.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(moneyBankPicker.snp.bottom).offset(15)
            make.height.equalTo(ProgressViewConstants.graphViewHeight)
            make.width.equalTo(ProgressViewConstants.graphViewWidth)
        }
    }
    
    func constraintsCigaretteGraphView() {
        cigaretteGraphView.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(cigaretteBankPicker.snp.bottom).offset(15)
            make.height.equalTo(ProgressViewConstants.graphViewHeight)
            make.width.equalTo(ProgressViewConstants.graphViewWidth)
        }
    }
    
    func constraintsMoneyGraphButton() {
        moneyGraphButton.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(cigaretteGraphView.snp.leading).offset(-10)
            make.centerY.equalTo(moneyGraphView.snp.centerY)
            make.height.equalTo(ProgressViewConstants.graphButtonDiameter )
            make.width.equalTo(ProgressViewConstants.graphButtonDiameter)
        }
    }
    
    func constraintsCigaretteGraphButton() {
        cigaretteGraphButton.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(moneyGraphView.snp.trailing).offset(10)
            make.centerY.equalTo(cigaretteGraphView.snp.centerY)
            make.height.equalTo(ProgressViewConstants.graphButtonDiameter)
            make.width.equalTo(ProgressViewConstants.graphButtonDiameter)
        }
    }
    
    
    //MARK: SUPPORT FUNC
    
    func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        
        scrollView.addSubview(userImageView)
        scrollView.addSubview(moneyBankPicker)
        scrollView.addSubview(cigaretteBankPicker)
        graphBackgroundView.addSubview(moneyGraphView)
        graphBackgroundView.addSubview(cigaretteGraphView)
        graphBackgroundView.addSubview(moneyGraphButton)
        graphBackgroundView.addSubview(cigaretteGraphButton)
        scrollView.addSubview(graphBackgroundView)
        self.addSubview(scrollView)
        
        constraintsScrollView()
        constraintsUserImageView()
        constraintsMoneyBankPicker()
        constraintsCigaretteBankPicker()
        constraintsGraphBackgroundView()
        constraintsMoneyGraphView()
        constraintsCigaretteGraphView()
        constraintsMoneyGraphButton()
        constraintsCigaretteGraphButton()
    }
    
    func drawGraphButtonArc(center: CGPoint,start: CGFloat, end: CGFloat, callback: @escaping(CAShapeLayer) -> Void){
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: ProgressViewConstants.graphButtonArcRadius,
                    startAngle: start,
                    endAngle:  end,
                    clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.1582991481, green: 0.1590825021, blue: 0.1307061911, alpha: 1).cgColor
        shapeLayer.name =  ProgressViewString.graphButtonCircleLayerName.rawValue
        callback(shapeLayer)
    }
}

//MARK: ANIMATION EXTENSION

extension ProgressView {
    func switchGraphs(_ setup: [GraphSetup], _ graphType: GraphType){
        var fromButton: UIButton!
        var toButton: UIButton!
        var fromView: UIGraphView!
        var toView: UIGraphView!
        var buttonArcCenter: CGPoint!
        var startAngle: CGFloat!
        var endAngele: CGFloat!
        var animationOptions:UIView.AnimationOptions!
        
        switch graphType {
        case .money:
            fromButton = self.moneyGraphButton
            toButton = self.cigaretteGraphButton
            fromView = self.cigaretteGraphView
            toView = self.moneyGraphView
            buttonArcCenter = CGPoint(x: self.moneyGraphView.bounds.width - 5, y: self.moneyGraphView.bounds.height / 2)
            startAngle = 270 * .pi / 180
            endAngele = 90 * .pi / 180
            animationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        case .cigarette:
            fromButton = self.cigaretteGraphButton
            toButton = self.moneyGraphButton
            fromView = self.moneyGraphView
            toView = self.cigaretteGraphView
            buttonArcCenter = CGPoint(x: 5, y: self.cigaretteGraphView.bounds.height / 2)
            startAngle = 90 * .pi / 180
            endAngele = 270 * .pi / 180
            animationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        }
        
        fromButton.alpha = 0
        fromButton.isUserInteractionEnabled = false
        
        fromView.layer.sublayers?.forEach {
            if ($0.name == ProgressViewString.graphButtonCircleLayerName.rawValue){
                $0.removeFromSuperlayer()
            }
        }
        
        self.drawGraphButtonArc(center: buttonArcCenter , start: startAngle, end: endAngele) {shapeLayer in
            toView.layer.insertSublayer(shapeLayer, at: 1)
        }
        
        UIView.transition(
            from: fromView,
            to: toView,
            duration: 1,
            options: animationOptions,
            completion: {_ in
                toView.showGraphs(setup)
                UIView.animate(withDuration: 0.3){
                    toButton.alpha = 0.7
                    toButton.isUserInteractionEnabled = true
                }
                
            }
        )
    }
}
