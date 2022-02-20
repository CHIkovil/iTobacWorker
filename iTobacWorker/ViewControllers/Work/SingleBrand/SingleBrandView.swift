//
//  SingleBrandView.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.02.2022.
//

import Foundation

import UIKit

//MARK: STRING

private enum SingleBrandViewString: String {
    case closeButtonImageName = "close"
}

//MARK: CONSTANTS

private enum SingleBrandViewConstants {
    static let closeButtonOffset = 20
    static let imageViewHeight = 300.0
}

class SingleBrandView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    //MARK: UI
    
    lazy var brandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AppString.fontName.rawValue, size: 20)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:SingleBrandViewString.closeButtonImageName.rawValue), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    //MARK: CONSTRAINTS
    
    func constraintsBrandImageView() {
        brandImageView.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(self.snp.top)
            make.height.equalTo(SingleBrandViewConstants.imageViewHeight)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    func constraintsBrandLabel() {
        brandLabel.snp.makeConstraints {(make) -> Void in
            make.center.equalTo(brandImageView.snp.center)
            make.width.equalTo(SingleBrandViewConstants.imageViewHeight * 0.7)
            make.height.equalTo(SingleBrandViewConstants.imageViewHeight * 0.3)
        }
    }
    
    func constraintsCloseButton() {
        closeButton.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(brandImageView.snp.top).offset(SingleBrandViewConstants.closeButtonOffset)
            make.trailing.equalTo(brandImageView.snp.trailing).offset(-SingleBrandViewConstants.closeButtonOffset)
            make.width.equalTo(SingleBrandViewConstants.imageViewHeight * 0.15)
            make.height.equalTo(SingleBrandViewConstants.imageViewHeight * 0.15)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        self.addSubview(brandImageView)
        self.addSubview(brandLabel)
        self.addSubview(closeButton)
        
        constraintsBrandImageView()
        constraintsBrandLabel()
        constraintsCloseButton()
    }
}
