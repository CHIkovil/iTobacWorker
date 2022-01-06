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
    case lineLayerName = "line"
}

//MARK: CONSTANTS

private enum WakeUpTextFieldConstants{
    static let defTextSize: CGFloat = 13.5
    static let lineWidth: CGFloat = 2
}

final class WakeUpTextField: UIView {
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    // MARK: showInputField
    func showInputField(){
        drawLineLayer(color: #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1)) {lineLayer in
            lineLayer.addActivationAnimation()
            self.layer.addSublayer(lineLayer)
        }

        animateInputField()
    }
    
    //MARK: PRIVATE
    private var lineStartPoint:CGPoint {CGPoint(x: 15, y: self.frame.height + 5)}
    private var lineEndPoint:CGPoint {CGPoint(x: self.frame.width - 15, y: self.frame.height + 5)}
    private var textFieldWidth: CGFloat {self.frame.width}
    private var textFieldHeight: CGFloat {self.frame.height}
    
    //MARK:  UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: GlobalString.fontName.rawValue, size: WakeUpTextFieldConstants.defTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = WakeUpTextFieldString.titleLabelText.rawValue
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: GlobalString.fontName.rawValue, size: WakeUpTextFieldConstants.defTextSize + 1.5)
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
        self.addSubview(titleLabel)
        self.addSubview(textField)
        
        constraintsTitleLabel()
        constraintsTextField()
        
        showLine()
    }
    
    private func showLine(){
        self.layer.sublayers?.forEach {
            if ($0.name == WakeUpTextFieldString.lineLayerName.rawValue){
                $0.removeFromSuperlayer()
            }
        }
        
        drawLineLayer( color: .lightGray) { shapeLayer in
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    private func drawLineLayer(color: UIColor, callback: @escaping(CAShapeLayer) -> Void) {
        let path = UIBezierPath()
        path.move(to: lineStartPoint)
        path.addLine(to: lineEndPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = WakeUpTextFieldConstants.lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.name = WakeUpTextFieldString.lineLayerName.rawValue
        
        callback(shapeLayer)
    }
}

//MARK: ANIMATION EXTENSION

private extension WakeUpTextField {
    func animateInputField(){
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let self = self else{return}
            self.titleLabel.transform.ty = -abs(self.textField.frame.height)
        },completion: {_ in
            UIView.animate(withDuration: 0.5) {[weak self] in
                guard let self = self else{return}
                self.textField.alpha = 1
            }
        })
    }
   
}
