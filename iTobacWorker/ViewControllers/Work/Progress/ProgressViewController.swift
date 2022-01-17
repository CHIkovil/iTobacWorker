//
//  ProgressViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 07.12.2021.
//

import UIKit

// MARK: DELEGATE

protocol ProgressViewDelegate: AnyObject{
    func showUserData(_ data: UserData)
}

// MARK: STRING

private enum ProgressViewControllerString: String {
    case normGraphAnnotation = "Norm"
    case countGraphAnnotation = "Count"
}

class ProgressViewController: UIViewController
{
    var imagePicker: ImagePicker!
    
    var progressView: ProgressView!
    var progressStoreDelegate: ProgressStoreDelegate!
    
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
        progressStoreDelegate = ProgressPresenter(delegate: self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.progressView = ProgressView()
        view = progressView
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        progressView.userImageView.addButtonGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressAddPhotoButton)))
        progressView.moneyGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressMoneyGraphButton)))
        progressView.cigaretteGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressCigaretteGraphButton)))
        progressView.moneyNormView.addTextFieldTarget(target: self, action:  #selector(moneyNormChanged), event: .editingChanged)
        progressView.cigaretteNormView.addTextFieldTarget(target: self, action:  #selector(cigaretteNormChanged), event: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.moneyBankPicker.animateAttention()
        progressView.cigaretteBankPicker.animateAttention()
        progressStoreDelegate.loadUserData()
    }
    
    // MARK: OBJC
    
    @objc func didPressAddPhotoButton() {
        progressView.userImageView.animateImagePulse()
        self.imagePicker.present()
    }
    
    @objc func didPressMoneyGraphButton() {
        progressView.switchGraphs(newGraphs: nil, .money)
    }
    
    @objc func didPressCigaretteGraphButton() {
        progressView.switchGraphs(newGraphs: nil, .cigarette)
    }
    
    @objc func moneyNormChanged() {
     
    }
    
    @objc func cigaretteNormChanged() {
 
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

extension ProgressViewController: ProgressViewDelegate {
    func showUserData(_ data: UserData) {
        if let imageData = data.image as Data? {
            if let image = UIImage(data: imageData){
                progressView.userImageView.setImage(image: image)
            }
        }
        
        progressView.moneyBankPicker.setCountValue(data.moneyProgress.bank)
        progressView.cigaretteBankPicker.setCountValue(data.cigaretteProgress.bank)
        
        
        progressView.moneyNormView.setNormValue(data.moneyProgress.norm.last!)
        progressView.cigaretteNormView.setNormValue(data.cigaretteProgress.norm.last!)
        

        
        progressView.switchGraphs(newGraphs: [GraphSetup(points: data.moneyProgress.count, color: UIColor(white: 0.8, alpha: 0.9), annotation: ProgressViewControllerString.countGraphAnnotation.rawValue), GraphSetup(points: data.moneyProgress.norm, color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: ProgressViewControllerString.normGraphAnnotation.rawValue)],.money)
        
        progressView.cigaretteGraphView.setGraphs([GraphSetup(points: data.cigaretteProgress.count, color: UIColor(white: 0.8, alpha: 0.9), annotation: ProgressViewControllerString.countGraphAnnotation.rawValue), GraphSetup(points: data.cigaretteProgress.norm, color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: ProgressViewControllerString.normGraphAnnotation.rawValue)])
        
    }
}

