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
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    //MARK: touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: self) else {return}
        if (!titleLabel.frame.contains(touchLocation) || !inputTextField.frame.contains(touchLocation)) {return}
        activateLine()
        titleLabel.transform.ty = -inputTextField.frame.height
        inputTextField.alpha = 1
        inputTextField.isEnabled = true
    }
    
    //MARK: PRIVATE UI
    
    
    
    //MARK: titleLabel
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.backgroundColor = .clear
        label.font = UIFont(name: "Chalkduster", size: 13.6)
        label.text = "Email or Username"
        return label
    }()
    
    //MARK: inputTextField
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.tintColor = .clear
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(5)
        textField.alpha = 0
        textField.isEnabled = false
        textField.font = UIFont(name: "Chalkduster", size: 16)
        return textField
    }()
    
    
}

//MARK: PRIVATE UI FUNC
private extension WakeUpTextField {
    
    
    //MARK: CONSTRAINTS
    
    
    
    //MARK: constraintsTitleLabel
    func constraintsTitleLabel(){
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(32)
            make.left.equalTo(inputTextField.snp.left)
            make.bottom.equalTo(inputTextField.snp.bottom)
        }
    }
    
    //MARK: constraintsInputTextField
    func constraintsInputTextField(){
        inputTextField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(30)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    
    //MARK: SUPPORT FUNC
    
    
    
    
    // MARK: makeUI
    func makeUI() {
        let lineLayer = drawLineFromPoint(start: CGPoint(x: 6, y: 85), toPoint: CGPoint(x: 144, y: 85), color: .lightGray, width: 2)
        
        self.layer.addSublayer(lineLayer)
        self.addSubview(titleLabel)
        self.addSubview(inputTextField)
        
        constraintsTitleLabel()
        constraintsInputTextField()
    }
    
    //MARK: drawLineFromPoint
    func drawLineFromPoint(start: CGPoint, toPoint end: CGPoint, color: UIColor, width: CGFloat) ->  CAShapeLayer{
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
    
    //MARK: activateLine
    func activateLine(){
        let lineLayer = drawLineFromPoint(start: CGPoint(x: 6, y: 85), toPoint: CGPoint(x: self.frame.width - 6, y: 85), color: .yellow, width: 5)
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.8
        lineLayer.add(animation, forKey: "lineAnimation")
        
        self.layer.addSublayer(lineLayer)
    }
}

//MARK: PRIVATE UI EXTENSION
private extension UITextField{
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
