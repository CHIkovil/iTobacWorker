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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.userImageView.addButtonGestureRecognizer(gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(didPressAddPhotoButton)))
        
        progressView.userImageView.showFrame()
        progressView.moneyBankPicker.animateAttention()
        progressView.cigaretteBankPicker.animateAttention()
        
        progressView.graphView.showGraphs([Graph(points: [4, 2, 6, 4, 5, 8, 3], color: UIColor(white: 0.8, alpha: 0.9)), Graph(points: [1, 3, 4, 4, 7, 8, 3], color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9))], isAnimate: true)
        
    }
    
    // MARK: OBJC
    
    @objc func didPressAddPhotoButton() {
        progressView.userImageView.animateImagePulse()
        self.imagePicker.present()
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

