//
//  AuthorizationView.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import SnapKit


class AuthorizationView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }

    //MARK: UI
    
    lazy var boardView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1)
        view.alpha = 0
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 3
        view.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var appLabel: AbbreviationLabel = {
        let label = AbbreviationLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    lazy var loginTextField: WakeUpTextField = {
        let textField = WakeUpTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: CONSTRAINTS
    
    func constraintsBoardView() {
        boardView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(300)
            make.center.equalTo(self.snp.center)
        }
    }
    
    func constraintsTitleAppLabel() {
        appLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(70)
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func constraintsLoginTextField() {
        loginTextField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(220)
            make.height.equalTo(100)
            make.bottom.equalTo(self.snp.centerY).offset(10)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        boardView.addSubview(loginTextField)
        self.addSubview(boardView)
        self.addSubview(appLabel)
        
        constraintsBoardView()
        constraintsTitleAppLabel()
        constraintsLoginTextField()
    }
}
