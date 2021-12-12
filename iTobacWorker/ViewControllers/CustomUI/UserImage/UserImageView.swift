//
//  UserImageView.swift
//  iTobacWorker
//
//  Created by Nikolas on 09.12.2021.
//

import Foundation
import UIKit

private enum UserImageViewString: String {
    case startImageName = "question"
    case addImageName = "add"
    case arcAnimationKey = "arcAnimation"
    case basicAnimationKey = "transform.rotation"
    case arcLayerName = "arcLayer"
}

class UserImageView: UIView {
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    // MARK: showFrame
    func showFrame(){
        self.layer.sublayers?.forEach {
            guard let name = $0.name else{return}
            if (name.starts(with: UserImageViewString.arcLayerName.rawValue)){
                $0.removeFromSuperlayer()
            }
        }
        let animation = getArcAnimation()
        for index in 1...3 {
            let shapeLayer = drawArcShapeLayer(name:UserImageViewString.arcLayerName.rawValue + "\(index)", offset: CGFloat(index))
            shapeLayer.add(animation, forKey: UserImageViewString.arcAnimationKey.rawValue)
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    // MARK: setImage
    func setImage(image: UIImage){
        imageView.image = image
    }
    
    // MARK: addButtonTarget
    func addButtonTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event){
        addButton.addTarget(target, action: action, for: controlEvents)
    }
    
    // MARK: PRIVATE
    
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    
    // MARK: UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: UserImageViewString.startImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = (viewWidth + viewHeight) * 0.15
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.9983720183, green: 0.890299499, blue: 0.4330784082, alpha: 1)
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        return imageView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: UserImageViewString.addImageName.rawValue), for: .normal)
        button.layer.cornerRadius = 0.09
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.alpha = 0.9
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = (viewWidth + viewHeight) * 0.15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        return view
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsBackgroundView() {
        backgroundView.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.6)
            make.width.equalTo(viewWidth * 0.6)
            make.center.equalTo(self.snp.center)
        }
    }
    
    private func constraintsImageView() {
        imageView.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.6)
            make.width.equalTo(viewWidth * 0.6)
            make.center.equalTo(self.snp.center)
        }
    }
    
    private func constraintsAddButton() {
        addButton.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.18)
            make.width.equalTo(viewWidth * 0.18)
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalTo(imageView.snp.trailing).offset(-15)
        }
    }
    
    // MARK: SUPPORT FUNC
    
    private func makeUI(){
        backgroundView.addSubview(imageView)
        self.addSubview(backgroundView)
        self.addSubview(addButton)
        
        constraintsBackgroundView()
        constraintsImageView()
        constraintsAddButton()
    }
    
    
    private func drawArcShapeLayer(name: String, offset: CGFloat) -> CAShapeLayer{
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: viewWidth / 2, y: viewHeight / 2)
        let bounds = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        let startAngle = CGFloat.pi / 180 * CGFloat.random(in: 0...360)
        
        shapeLayer.path = UIBezierPath(arcCenter: center,
                                          radius: (viewWidth + viewHeight)  * 0.15 + offset * 5,
                                          startAngle: startAngle,
                                          endAngle: startAngle * CGFloat.random(in: 0...100) / 100,
                                          clockwise: true).cgPath
//        shapeLayer.strokeColor = #colorLiteral(red: 0.8816937208, green: 0.9067572951, blue: 0.9233501554, alpha: 1).cgColor
        shapeLayer.strokeColor = #colorLiteral(red: 0.7908198833, green: 0.8205971718, blue: 0.8312640786, alpha: 1).cgColor
        shapeLayer.lineWidth = offset
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.name = name
        
        shapeLayer.position = center
        shapeLayer.bounds = bounds
        return shapeLayer
    }
    
    // MARK: ANIMATION
    
    private func getArcAnimation() -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: UserImageViewString.basicAnimationKey.rawValue)
        animation.byValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        animation.duration = 10
        animation.repeatCount = .infinity
        return animation
    }
}

