//
//  BankPicker.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.12.2021.
//

import Foundation
import UIKit

private enum BankPickerString:String{
    case fontName = "Chalkduster"
    case animationKey =  "position"
    case buttonImageName = "enter"
}

final class BankPicker: UIView{
    var image: UIImage?
    var textSize: CGFloat?
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
        
    //MARK: showAttention
    func showAttention(){
        imageView.animateShake()
    }
    
    //MARK: PRIVATE
    private var viewWidth: CGFloat {self.frame.width}
    private var viewHeight: CGFloat {self.frame.height}
    
    
    //MARK: UI
    
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .clear
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressImage)))
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPressImage)))
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "\(0)"
        label.textColor = .lightGray
        label.font = UIFont(name: BankPickerString.fontName.rawValue, size: textSize ?? 25)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        textField.font = UIFont(name: BankPickerString.fontName.rawValue, size: textSize ?? 25)
        textField.setLeftPaddingPoints(12)
        textField.backgroundColor = #colorLiteral(red: 0.1412108243, green: 0.1412418485, blue: 0.1412067413, alpha: 1)
        textField.alpha = 0
        textField.delegate = self
        textField.textColor = .lightGray
        textField.layer.cornerRadius = 10
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var inputButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: BankPickerString.buttonImageName.rawValue), for: .normal)
        button.layer.cornerRadius = button.frame.width / 2
        button.alpha = 0
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressInputButton)))
        return button
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
            make.height.equalTo(viewHeight * 0.19)
            make.width.equalTo(viewWidth * 0.9)
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalTo(imageView.snp.centerX)
        }
    }
    
    private func constraintsInputTextField() {
        inputTextField.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.19)
            make.width.equalTo(viewWidth * 0.55)
            make.center.equalTo(label.snp.center)
        }
    }

    private func constraintsInputButton() {
        inputButton.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.17)
            make.width.equalTo(viewWidth * 0.17)
            make.centerY.equalTo(inputTextField.snp.centerY)
            make.leading.equalTo(inputTextField.snp.trailing).offset(2)
        }
    }

    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        self.layer.drawBlockLayer(cornerWidth: 25)
        
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(inputTextField)
        self.addSubview(inputButton)
        constraintsImageView()
        constraintsLabel()
        constraintsInputTextField()
        constraintsInputButton()
        
        guard let image = image else{return}
        imageView.image = image
    }
    
    private func addBankValue(at newValue: Int){
        if let number = NumberFormatter().number(from: label.text!) {
            let oldValue = Int(truncating: number)
            label.text = "\(oldValue + newValue)"
        }
        label.animateDropDown()
    }
    
    // MARK: OBJC
    @objc func didPressImage() {
        addBankValue(at: 1)
    }
    
    @objc func didLongPressImage() {
        label.alpha = 0
        inputTextField.animateStepOpacity(next: inputButton, newAlpha: 1)
        inputTextField.isUserInteractionEnabled = true
        inputButton.isUserInteractionEnabled = true
    }
    
    @objc func didPressInputButton() {
        guard let text = inputTextField.text else {return}
        inputTextField.animateStepOpacity(next: inputButton, newAlpha: 0)
        inputButton.isUserInteractionEnabled = false
        inputTextField.isUserInteractionEnabled = false
        label.alpha = 1
        guard let value = Int(text) else {return}
        addBankValue(at: value)
    }
}

//MARK: UI ANIMATION EXTENSION

private extension UIView {
    func animateShake(){
        let animation = CABasicAnimation(keyPath: BankPickerString.animationKey.rawValue)
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 1.5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 1.5, y: self.center.y))
        self.layer.add(animation, forKey: BankPickerString.animationKey.rawValue)
    }
    
    func animateStepOpacity(next: UIView, newAlpha: CGFloat){
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let self = self else{return}
            self.alpha = newAlpha
        }, completion: { _ in
            next.alpha = newAlpha
        })
    }
    
    func animateDropDown(){
        let animation = CABasicAnimation(keyPath: BankPickerString.animationKey.rawValue)
        animation.duration = 0.7
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y - 5))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
        self.layer.add(animation, forKey: BankPickerString.animationKey.rawValue)
    }
}

//MARK: DELEGATE EXTENSION

extension BankPicker: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
