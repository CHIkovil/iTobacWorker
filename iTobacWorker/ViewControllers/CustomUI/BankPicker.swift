//
//  BankPicker.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.12.2021.
//

import Foundation
import UIKit

//MARK: STRING

private enum BankPickerString:String{
    case animationKey =  "position"
    case buttonImageName = "plus"
}

//MARK: CONSTANTS

private enum BankPickerConstants{
    static let defTextSize: CGFloat = 28
}

final class BankPicker: UIView{
    var image: UIImage?
    var textSize: CGFloat?
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
        
    //MARK: animateAttention
    func animateAttention(){
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
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(0)"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
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
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
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
    
    private func constraintsCountLabel() {
        countLabel.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.21)
            make.width.equalTo(viewWidth * 0.9)
            make.top.equalTo(imageView.snp.bottom).offset(2)
            make.centerX.equalTo(imageView.snp.centerX)
        }
    }
    
    private func constraintsInputTextField() {
        inputTextField.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.19)
            make.width.equalTo(viewWidth * 0.55)
            make.centerX.equalTo(countLabel.snp.centerX).offset(-5)
            make.centerY.equalTo(countLabel.snp.centerY)
        }
    }

    private func constraintsInputButton() {
        inputButton.snp.makeConstraints {(make) -> Void in
            make.height.equalTo(viewHeight * 0.17)
            make.width.equalTo(viewWidth * 0.17)
            make.centerY.equalTo(inputTextField.snp.centerY)
            make.leading.equalTo(inputTextField.snp.trailing).offset(5)
        }
    }

    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        let color = #colorLiteral(red: 0.1261322796, green: 0.1471925974, blue: 0.2156360745, alpha: 1)
        
        self.layer.drawBlockLayer(cornerWidth: 25,color: color)
        self.addSubview(imageView)
        self.addSubview(countLabel)
        self.addSubview(inputTextField)
        self.addSubview(inputButton)
        constraintsImageView()
        constraintsCountLabel()
        constraintsInputTextField()
        constraintsInputButton()
        
        countLabel.font = UIFont(name: GlobalString.fontName.rawValue, size: textSize ?? BankPickerConstants.defTextSize)
        inputTextField.font = UIFont(name: GlobalString.fontName.rawValue, size: textSize ?? (BankPickerConstants.defTextSize - 5))
        guard let image = image else{return}
        imageView.image = image
    }
    
    private func addBankValue(at newValue: Int){
        if let number = NumberFormatter().number(from: countLabel.text!) {
            let oldValue = Int(truncating: number)
            countLabel.text = "\(oldValue + newValue)"
        }
        countLabel.animateDrop()
        imageView.animateShake()
    }
    
    private func switchInputField(at isEnabled: Bool){
        inputTextField.isUserInteractionEnabled = isEnabled
        inputButton.isUserInteractionEnabled = isEnabled
        countLabel.alpha = isEnabled ? 0 : 1
    }
    
    // MARK: OBJC
    @objc func didPressImage() {
        addBankValue(at: 1)
    }
    
    @objc func didLongPressImage() {
        animateStateInputField(newAlpha: 1, isInputEnabled: true)
    }
    
    @objc func didPressInputButton() {
        guard let text = inputTextField.text else {return}
        animateStateInputField(newAlpha: 0, isInputEnabled: false)
        guard let value = Int(text) else {return}
        addBankValue(at: value)
    }
}

//MARK: UI ANIMATION EXTENSION

private extension BankPicker {
    func animateStateInputField(newAlpha: CGFloat, isInputEnabled: Bool){
        inputTextField.text = String()
        UIView.animate(withDuration: 0.1, animations: {[weak self] in
            guard let self = self else{return}
            self.inputTextField.alpha = newAlpha
        }, completion: { _ in
            self.inputButton.alpha = newAlpha - 0.1
        })
        switchInputField(at: isInputEnabled)
    }
}

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
    
    func animateDrop(){
        let animation = CABasicAnimation(keyPath: BankPickerString.animationKey.rawValue)
        animation.duration = 0.7
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y - 4))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
        self.layer.add(animation, forKey: BankPickerString.animationKey.rawValue)
    }
}

//MARK: DELEGATE EXTENSION

extension BankPicker: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let newLength = text.count + string.count - range.length
        return allowedCharacters.isSuperset(of: characterSet) && newLength <= 4
    }
}
