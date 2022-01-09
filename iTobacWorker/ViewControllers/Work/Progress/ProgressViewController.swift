//
//  ProgressViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 07.12.2021.
//

import UIKit

// MARK: STRING

private enum ProgressViewControllerString: String {
    case normGraphAnnotation = "Norm"
    case countGraphAnnotation = "Count"
}

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
        view = progressView
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        progressView.userImageView.addButtonGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressAddPhotoButton)))
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
        progressView.switchGraphs([GraphSetup(points: [4, 2, 6, 4, 5, 8, 3], color: UIColor(white: 0.8, alpha: 0.9), annotation: ProgressViewControllerString.countGraphAnnotation.rawValue), GraphSetup(points: [1, 3, 4, 4, 7, 8, 3], color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: ProgressViewControllerString.normGraphAnnotation.rawValue)], .money)
    }
    
    @objc func didPressCigaretteGraphButton() {
        progressView.switchGraphs([GraphSetup(points: [4, 2, 6, 4, 5, 8, 0], color: UIColor(white: 0.8, alpha: 0.9), annotation: ProgressViewControllerString.countGraphAnnotation.rawValue), GraphSetup(points: [1, 3, 4, 4, 7, 8, 0], color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: ProgressViewControllerString.normGraphAnnotation.rawValue)], .cigarette)
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

