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
        let progressView = ProgressView()
        self.progressView = progressView
        self.progressView.imagePicker = ImagePicker(presentationController: self, delegate: self)
        view = progressView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.userImageView.addButtonTarget(self, action: #selector(didPressAddPhotoButton), for: .touchUpInside)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressAddPhotoButton))
        progressView.userImageView.addButtonGestureRecognizer(gestureRecognizer: longGesture)
        
        progressView.userImageView.showFrame()
    }
    
    // MARK: OBJC
    
    @objc func didPressAddPhotoButton() {
        self.progressView.imagePicker.present()
    }
    
    @objc func didLongPressAddPhotoButton() {
        progressView.userImageView.animateImage()
        self.progressView.imagePicker.present()
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

