//
//  WakeUpTextField.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import SnapKit

//MARK: STRING

private enum WakeUpTextFieldString: String {
    case titleLabelText = "Email or Username"
    case lineAnimationKey = "strokeEnd"
}

//MARK: CONSTANTS

private enum WakeUpTextFieldConstants{
    static let defTextSize: CGFloat = 13.5
    static let lineWidth: CGFloat = 2
}

final class WakeUpTextField: UIView {
    
    var textSize: CGFloat?
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    // MARK: animateInputField
    func animateInputField(){
        animateTitleUp()
        animateShowTextField()
        
        let lineLayer = drawLineFromPoint(start: lineStartPoint, toPoint: lineEndPoint, color: #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1), width: WakeUpTextFieldConstants.lineWidth)
        lineLayer.addActivationAnimation()
        self.layer.addSublayer(lineLayer)
    }
    
    //MARK: PRIVATE
    private var lineStartPoint:CGPoint {CGPoint(x: 15, y: self.frame.height + 5)}
    private var lineEndPoint:CGPoint {CGPoint(x: self.frame.width - 15, y: self.frame.height + 5)}
    private var textFieldWidth: CGFloat {self.frame.width}
    private var textFieldHeight: CGFloat {self.frame.height}
    
    //MARK:  UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = WakeUpTextFieldString.titleLabelText.rawValue
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var textField: UITextField = {
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
            make.centerX.equalTo(textField.snp.centerX)
            make.bottom.equalTo(textField.snp.bottom)
        }
    }
    
    private func constraintsTextField(){
        textField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(textFieldHeight * 0.44)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        let lineLayer = drawLineFromPoint(start: lineStartPoint, toPoint: lineEndPoint, color: .lightGray, width: WakeUpTextFieldConstants.lineWidth)
        self.layer.addSublayer(lineLayer)
        
        
        titleLabel.font = UIFont(name: GlobalString.fontName.rawValue, size: textSize ?? WakeUpTextFieldConstants.defTextSize)
        textField.font = UIFont(name: GlobalString.fontName.rawValue, size: textSize ?? (WakeUpTextFieldConstants.defTextSize + 1.5))
     
        self.addSubview(titleLabel)
        self.addSubview(textField)
        
        constraintsTitleLabel()
        constraintsTextField()
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
}

//MARK: UI ANIMATION EXTENSION

private extension WakeUpTextField {
    func animateTitleUp(){
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else{return}
            self.titleLabel.transform.ty = -abs(self.textField.frame.height)
        }
    }
    
    func animateShowTextField(){
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else{return}
            self.textField.alpha = 1
        }
    }
}

private extension CALayer {
    func addActivationAnimation(){
        let animation : CABasicAnimation = CABasicAnimation(keyPath: WakeUpTextFieldString.lineAnimationKey.rawValue)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1
        self.add(animation, forKey: WakeUpTextFieldString.lineAnimationKey.rawValue)
    }
}
