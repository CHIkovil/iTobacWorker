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
    
    lazy var moneyBankPicker: BankPicker = {
        let imageView = BankPicker()
        imageView.image = UIImage(named: ProgressViewString.moneyBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cigaretteBankPicker: BankPicker = {
        let imageView = BankPicker()
        imageView.image = UIImage(named: ProgressViewString.cigaretteBankImageName.rawValue)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var graphView: GraphView = {
        let view = GraphView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    //MARK: SUPPORT FUNC
    
    func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        
        scrollView.addSubview(userImageView)
        scrollView.addSubview(moneyBankPicker)
        scrollView.addSubview(cigaretteBankPicker)
        scrollView.addSubview(graphView)
        self.addSubview(scrollView)
        
        constraintsScrollView()
        constraintsUserImageView()
        constraintsMoneyBankPicker()
        constraintsCigaretteBankPicker()
        constraintsGraphView()
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
            make.top.equalTo(scrollView.snp.top).offset(50)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.height.equalTo(240)
            make.width.equalTo(240)
        }
    }
    
    func constraintsMoneyBankPicker() {
        moneyBankPicker.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.trailing.equalTo(scrollView.snp.centerX).offset(-5)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
    }
    
    func constraintsCigaretteBankPicker() {
        cigaretteBankPicker.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.leading.equalTo(scrollView.snp.centerX).offset(5)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
    }
    
    func constraintsGraphView() {
        graphView.snp.makeConstraints {(make) -> Void in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalTo(moneyBankPicker.snp.bottom).offset(15)
            make.height.equalTo(250)
            make.width.equalTo(280)
        }
    }
}
