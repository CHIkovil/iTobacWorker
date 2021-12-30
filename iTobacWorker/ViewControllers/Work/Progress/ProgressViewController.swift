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
        
        progressView.userImageView.animateFrame()
        progressView.moneyBankPicker.animateAttention()
        progressView.cigaretteBankPicker.animateAttention()
        progressView.graphView.animateGraph(gPoints: [4, 2, 6, 4, 5, 8, 3],color: .white, isAnimate: true)
        progressView.graphView.animateGraph(gPoints: [1, 3, 4, 4, 7, 8, 3], color: .green, isAnimate: true)
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

