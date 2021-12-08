//
//  WakeUpTextField.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import SnapKit

final class WakeUpTextField: UIView {
    
    // MARK: draw
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    // MARK: showTextField
    func showTextField(){
        animateLabel()
        animateLine()
    }
    
    //MARK: PRIVATE
    
    private var lineStartPoint:CGPoint {CGPoint(x: 15, y: 85)}
    private var lineEndPoint:CGPoint {CGPoint(x: 185, y: 85)}
    
    //MARK:  UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        label.font = UIFont(name: "Chalkduster", size: 13.6)
        label.text = "Email or Username"
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.font = UIFont(name: "Chalkduster", size: 16)
        textField.textColor = .black
        textField.tintColor = .clear
        textField.layer.cornerRadius = 15
        textField.setLeftPaddingPoints(12)
        textField.isUserInteractionEnabled = false
        textField.alpha = 0
        return textField
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsTitleLabel(){
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(32)
            make.centerX.equalTo(inputTextField.snp.centerX)
            make.bottom.equalTo(inputTextField.snp.bottom)
        }
    }
    
    private func constraintsInputTextField(){
        inputTextField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(40)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        let lineLayer = drawLineFromPoint(start: lineStartPoint, toPoint: lineEndPoint, color: .lightGray, width: 2)
        
        self.layer.addSublayer(lineLayer)
        
        self.addSubview(titleLabel)
        self.addSubview(inputTextField)
        
        constraintsTitleLabel()
        constraintsInputTextField()
    }
    
    private func drawLineFromPoint(start: CGPoint, toPoint end: CGPoint, color: UIColor, width: CGFloat) ->  CAShapeLayer{
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    //MARK: ANIMATION
    
    private func animateLabel(){
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else{return}
            self.titleLabel.transform.ty = -self.inputTextField.frame.height
            self.inputTextField.alpha = 1
        }
    }
    
    private func animateLine(){
        let lineLayer = drawLineFromPoint(start: lineStartPoint, toPoint: lineEndPoint, color: .yellow, width: 5)
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.8
        lineLayer.add(animation, forKey: "lineAnimation")
        
        self.layer.addSublayer(lineLayer)
    }
}

//MARK: UI EXTENSION

private extension UITextField{
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
