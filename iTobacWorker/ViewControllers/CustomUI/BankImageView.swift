//
//  BankImageView.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.12.2021.
//

import Foundation
import UIKit

private enum BankImageViewString:String{
    case fontName = "Chalkduster"
    case buttonImageName = "plus"
    case animationKey =  "position"
}

final class BankImageView: UIView{
    var image: UIImage?
    var textSize: CGFloat?
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: startAttentionAnimation
    func startAttentionAnimation(){
        imageView.animateShake()
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    
    //MARK: UI
    
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "\(0)"
        label.textColor = .lightGray
        label.font = UIFont(name: BankImageViewString.fontName.rawValue, size: textSize ?? 30)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsImageView() {
        imageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(viewWidth * 0.55)
            make.height.equalTo(viewHeight * 0.55)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-10)
        }
    }
    
    private func constraintsLabel() {
        label.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.2)
            make.width.equalTo(viewWidth * 0.9)
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(imageView.snp.centerX)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        self.layer.drawBlockLayer(cornerWidth: 25)
        
        self.addSubview(imageView)
        self.addSubview(label)
        constraintsImageView()
        constraintsLabel()
        
        guard let image = image else{return}
        imageView.image = image
    }
}

//MARK: UI ANIMATION EXTENSION

private extension UIImageView {
    
    func animateShake(){
        let animation = CABasicAnimation(keyPath: BankImageViewString.animationKey.rawValue)
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 1.5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 1.5, y: self.center.y))


        self.layer.add(animation, forKey: BankImageViewString.animationKey.rawValue)
    }
}
