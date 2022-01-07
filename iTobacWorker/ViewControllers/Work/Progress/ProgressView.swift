//
//  ProgressView.swift
//  iTobacWorker
//
//  Created by Nikolas on 08.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

enum ProgressViewString: String {
    case moneyBankImageName = "safe-box"
    case cigaretteBankImageName = "ashtray"
    case moneyGraphButtonImageName = "money"
    case cigaretteGraphButtonName = "cigarettes"
    case graphButtonCircleLayerName = "arc"
}

//MARK: CONSTANTS
enum ProgressViewConstants {
    static let graphButtonDiameter: CGFloat = 35
    static let graphButtonCircleRadius: CGFloat = 42
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
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
        return scrollView
    }()
    
    lazy var userImageView: UserImageView = {
        let imageView = UserImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var moneyBankPicker: BankPicker = {
        let imageView = BankPicker()
        imageView.image = UIImage(named: ProgressViewString.moneyBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cigaretteBankPicker: BankPicker = {
        let imageView = BankPicker()
        imageView.image = UIImage(named: ProgressViewString.cigaretteBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var backgroundGraphView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var moneyGraphView: GraphView = {
        let view = GraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    lazy var cigaretteGraphView: GraphView = {
        let view = GraphView()
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
            make.top.equalTo(scrollView.snp.top).offset(50)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.height.equalTo(240)
            make.width.equalTo(240)
        }
    }
    
    func constraintsMoneyBankPicker() {
        moneyBankPicker.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.trailing.equalTo(scrollView.snp.centerX).offset(-5)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
    }
    
    func constraintsCigaretteBankPicker() {
        cigaretteBankPicker.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.leading.equalTo(scrollView.snp.centerX).offset(5)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
    }
    
    func constraintsBackgroundGraphView() {
        backgroundGraphView.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(moneyBankPicker.snp.bottom).offset(15)
            make.height.equalTo(250)
            make.width.equalTo(330)
        }
    }
    
    func constraintsMoneyGraphView() {
        moneyGraphView.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(moneyBankPicker.snp.bottom).offset(15)
            make.height.equalTo(250)
            make.width.equalTo(260)
        }
    }
    
    func constraintsCigaretteGraphView() {
        cigaretteGraphView.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(cigaretteBankPicker.snp.bottom).offset(15)
            make.height.equalTo(250)
            make.width.equalTo(260)
        }
    }
    
    func constraintsMoneyGraphButton() {
        moneyGraphButton.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(cigaretteGraphView.snp.leading)
            make.centerY.equalTo(moneyGraphView.snp.centerY)
            make.height.equalTo(ProgressViewConstants.graphButtonDiameter )
            make.width.equalTo(ProgressViewConstants.graphButtonDiameter)
        }
    }
    
    func constraintsCigaretteGraphButton() {
        cigaretteGraphButton.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(moneyGraphView.snp.trailing)
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
        backgroundGraphView.addSubview(moneyGraphView)
        backgroundGraphView.addSubview(cigaretteGraphView)
        backgroundGraphView.addSubview(moneyGraphButton)
        backgroundGraphView.addSubview(cigaretteGraphButton)
        scrollView.addSubview(backgroundGraphView)
        self.addSubview(scrollView)
        
        constraintsScrollView()
        constraintsUserImageView()
        constraintsMoneyBankPicker()
        constraintsCigaretteBankPicker()
        constraintsBackgroundGraphView()
        constraintsMoneyGraphView()
        constraintsCigaretteGraphView()
        constraintsMoneyGraphButton()
        constraintsCigaretteGraphButton()
    }
    
    func drawGraphButtonArc(center: CGPoint,start: CGFloat, end: CGFloat, callback: @escaping(CAShapeLayer) -> Void){
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: ProgressViewConstants.graphButtonCircleRadius,
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
