//
//  ProgressView.swift
//  iTobacWorker
//
//  Created by Nikolas on 08.12.2021.
//

import Foundation
import UIKit

private enum ProgressViewString: String {
    case moneyBankImageName = "safe-box"
    case cigaretteBankImageName = "ashtray"
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
    
    lazy var moneyBankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ProgressViewString.moneyBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var cigaretteBankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ProgressViewString.cigaretteBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    //MARK: SUPPORT FUNC
    
    func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1846325099, green: 0.184974581, blue: 0.200987637, alpha: 1)
 
        
        scrollView.addSubview(userImageView)
        scrollView.addSubview(moneyBankImageView)
        scrollView.addSubview(cigaretteBankImageView)
        self.addSubview(scrollView)
        
        constraintsScrollView()
        constraintsUserImageView()
        constraintsMoneyBankImageView()
        constraintsCigaretteBankImageView()
    }
    
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
            make.top.equalTo(scrollView.snp.top).offset(80)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.height.equalTo(240)
            make.width.equalTo(240)
        }
    }
    
    func constraintsMoneyBankImageView() {
        moneyBankImageView.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(30)
            make.trailing.equalTo(scrollView.snp.centerX).offset(-30)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
    }
    
    func constraintsCigaretteBankImageView() {
        cigaretteBankImageView.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(moneyBankImageView.snp.top)
            make.leading.equalTo(scrollView.snp.centerX).offset(30)
            make.height.equalTo(90)
            make.width.equalTo(90)
        }
    }
}
