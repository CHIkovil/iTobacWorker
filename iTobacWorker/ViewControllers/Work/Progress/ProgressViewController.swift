//
//  ProgressViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 07.12.2021.
//

import UIKit



class ProgressViewController: UIViewController
{
    
    var progressView: ProgressView!
    var imagePicker: ImagePicker!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.progressView = ProgressView()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        view = progressView
        
        progressView.userImageView.addButtonGestureRecognizer(gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(didPressAddPhotoButton)))
        progressView.moneyGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressMoneyGraphButton)))
        progressView.cigaretteGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressCigaretteGraphButton)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.moneyBankPicker.animateAttention()
        progressView.cigaretteBankPicker.animateAttention()
        didPressMoneyGraphButton()
    }
    
    // MARK: OBJC
    
    @objc func didPressAddPhotoButton() {
        progressView.userImageView.animateImagePulse()
        self.imagePicker.present()
    }
    
    @objc func didPressMoneyGraphButton() {
        self.progressView.moneyGraphButton.alpha = 0
        self.progressView.moneyGraphButton.isUserInteractionEnabled = false
        self.progressView.cigaretteGraphView.layer.sublayers?.forEach {
            if ($0.name == ProgressViewString.graphButtonCircleLayerName.rawValue){
                $0.removeFromSuperlayer()
            }
        }
        self.progressView.drawGraphButtonArc(center: CGPoint(x: self.progressView.cigaretteGraphView.bounds.width - 8, y: self.progressView.cigaretteGraphView.bounds.height / 2), start: 270 * .pi / 180,end: 90 * .pi / 180) {shapeLayer in
            self.progressView.moneyGraphView.layer.insertSublayer(shapeLayer, at: 1)
        }
        
        UIView.transition(
            from: self.progressView.cigaretteGraphView,
            to: self.progressView.moneyGraphView,
            duration: 1,
            options: [.transitionFlipFromRight, .showHideTransitionViews],
            completion: {[weak self] _ in
                guard let self = self else {return}
                self.progressView.moneyGraphView.showGraphs([GraphSetup(points: [4, 2, 6, 4, 5, 8, 3], color: UIColor(white: 0.8, alpha: 0.9), annotation: "count"), GraphSetup(points: [1, 3, 4, 4, 7, 8, 3], color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: "norm")], isAnimate: true)
                UIView.animate(withDuration: 0.3){[weak self] in
                    guard let self = self else {return}
                    self.progressView.cigaretteGraphButton.alpha = 0.6
                    self.progressView.cigaretteGraphButton.isUserInteractionEnabled = true
                }
            }
        )
    }
    
    @objc func didPressCigaretteGraphButton() {
        self.progressView.cigaretteGraphButton.alpha = 0
        self.progressView.cigaretteGraphButton.isUserInteractionEnabled = false
        self.progressView.moneyGraphView.layer.sublayers?.forEach {
            if ($0.name == ProgressViewString.graphButtonCircleLayerName.rawValue){
                $0.removeFromSuperlayer()
            }
        }
        self.progressView.drawGraphButtonArc(center: CGPoint(x: 8, y: self.progressView.cigaretteGraphView.bounds.height / 2) , start: 90 * .pi / 180, end: 270 * .pi / 180) {shapeLayer in
            self.progressView.cigaretteGraphView.layer.insertSublayer(shapeLayer, at: 1)
        }
        
        UIView.transition(
            from: self.progressView.moneyGraphView,
            to: self.progressView.cigaretteGraphView,
            duration: 1,
            options: [.transitionFlipFromLeft, .showHideTransitionViews],
            completion: {[weak self] _ in
                guard let self = self else {return}
                self.progressView.cigaretteGraphView.showGraphs([GraphSetup(points: [4, 2, 6, 4, 5, 8, 3], color: UIColor(white: 0.8, alpha: 0.9), annotation: "count"), GraphSetup(points: [1, 3, 4, 4, 7, 8, 3], color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: "norm")], isAnimate: true)
                UIView.animate(withDuration: 0.3){[weak self] in
                    guard let self = self else {return}
                    self.progressView.moneyGraphButton.alpha = 0.6
                    self.progressView.moneyGraphButton.isUserInteractionEnabled = true
                }
                
            }
        )
    }
}

//MARK: DELEGATE EXTENSION

extension ProgressViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        progressView.userImageView.setImage(image: image)
    }
}

