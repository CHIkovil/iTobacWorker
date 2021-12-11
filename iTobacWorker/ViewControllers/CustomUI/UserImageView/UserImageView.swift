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
}

class UserImageView: UIView {
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    
    // MARK: UI
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = self.frame.width / 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        return view
    }()
   
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: UserImageViewString.startImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = self.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = #colorLiteral(red: 0.9983720183, green: 0.890299499, blue: 0.4330784082, alpha: 1)
      
        return imageView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: UserImageViewString.addImageName.rawValue), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.alpha = 0.9
        return button
    }()

    //MARK: CONSTRAINTS

    private func constraintsBackgroundView() {
        backgroundView.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height)
            make.width.equalTo(self.snp.width)
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    private func constraintsImageView() {
        imageView.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(self.snp.height)
            make.width.equalTo(self.snp.width)
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    private func constraintsAddButton() {
        addButton.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.top.equalTo(backgroundView.snp.bottom)
            make.leading.equalTo(self.snp.trailing).offset(-25)
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

//    private func showFrame(){
//
//    }
//
//    private func drawFrameLayer() -> CALayer{
//        let layer = CALayer()
//        return layer
//    }
//
//    private func drawFrameAnimation() -> CABasicAnimation{
//
//    }
//    
}
