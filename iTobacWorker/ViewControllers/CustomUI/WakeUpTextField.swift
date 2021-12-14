//
//  WakeUpTextField.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import SnapKit

private enum WakeUpTextFieldString: String {
    case titleText = "Email or Username"
    case fontName = "Chalkduster"
    case animationKey = "strokeEnd"
}

final class WakeUpTextField: UIView {
    
    var textSize: CGFloat?
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    // MARK: showTextField
    func showTextField(){
        animateLabel()
        animateLine()
    }
    
    //MARK: PRIVATE
    
    private var lineStartPoint:CGPoint {CGPoint(x: 15, y: self.frame.height + 5)}
    private var lineEndPoint:CGPoint {CGPoint(x: self.frame.width - 15, y: self.frame.height + 5)}
    private var lineWidth: CGFloat = 2
    private var textFieldWidth: CGFloat {self.frame.width}
    private var textFieldHeight: CGFloat {self.frame.height}
    
    //MARK:  UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = WakeUpTextFieldString.titleText.rawValue
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0.9386559129, green: 0.9388130307, blue: 0.9386352301, alpha: 1)
        textField.textColor = .black
        textField.tintColor = .clear
        textField.isUserInteractionEnabled = false
        textField.alpha = 0
        textField.setLeftPaddingPoints(12)
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsTitleLabel(){
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(textFieldHeight * 0.4)
            make.centerX.equalTo(inputTextField.snp.centerX)
            make.bottom.equalTo(inputTextField.snp.bottom)
        }
    }
    
    private func constraintsInputTextField(){
        inputTextField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(textFieldHeight * 0.4)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        let lineLayer = drawLineFromPoint(start: lineStartPoint, toPoint: lineEndPoint, color: .lightGray, width: lineWidth)
        self.layer.addSublayer(lineLayer)
        
        
        titleLabel.font = UIFont(name: WakeUpTextFieldString.fontName.rawValue, size: textSize ?? 13.5)
        inputTextField.font = UIFont(name: WakeUpTextFieldString.fontName.rawValue, size: (textSize ?? 14) + 1)
     
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
        let lineLayer = drawLineFromPoint(start: lineStartPoint, toPoint: lineEndPoint, color: #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1), width: lineWidth)
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: WakeUpTextFieldString.animationKey.rawValue)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1
        lineLayer.add(animation, forKey: WakeUpTextFieldString.animationKey.rawValue)
        
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
