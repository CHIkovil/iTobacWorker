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
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    //MARK: makeUI
    func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        boardView.addSubview(titleAppLabel)
        boardView.addSubview(loginTextField)
        self.addSubview(boardView)
        
        constraintsBoardView()
        constraintsTitleAppLabel()
        constraintsLoginTextField()
    }
    
    //MARK: UI
    private lazy var boardView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1598679423, green: 0.1648836732, blue: 0.1904173791, alpha: 1)
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var titleAppLabel: AbbreviationLabel = {
        let label = AbbreviationLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loginTextField: WakeUpTextField = {
        let textField = WakeUpTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
}

//MARK: CONSTRAINTS
private extension AuthorizationView {
    func constraintsBoardView() {
        boardView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(310)
            make.height.equalTo(310)
            make.center.equalTo(self.snp.center)
        }
    }
    
    func constraintsTitleAppLabel() {
        titleAppLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(70)
            make.bottom.equalTo(self.loginTextField.snp.top)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func constraintsLoginTextField() {
        loginTextField.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(80)
            make.bottom.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
}
