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
    func showUpdatedGraph(_ data: GraphData)
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
    var progressDelegate: (ProgressStoreDelegate & ProgressRecalculateDelegate)!
    
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
        progressDelegate = ProgressPresenter(delegate: self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.progressView = ProgressView()
        view = progressView
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.progressView.moneyBankPicker.delegate = self
        self.progressView.cigaretteBankPicker.delegate = self
        self.progressView.moneyNormPicker.delegate = self
        self.progressView.cigaretteNormPicker.delegate = self
        
        progressView.userImageView.addButtonGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressAddPhotoButton)))
        progressView.moneyGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressMoneyGraphButton)))
        progressView.cigaretteGraphButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressCigaretteGraphButton)))
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.moneyBankPicker.animateAttention()
        progressView.cigaretteBankPicker.animateAttention()
        progressDelegate.loadUserData()
    }
    
    // MARK: OBJC
    
    @objc func didPressAddPhotoButton() {
        progressView.userImageView.animateImagePulse()
        self.imagePicker.present()
    }
    
    @objc func didPressMoneyGraphButton() {
        progressView.switchGraphs(nil, .money)
    }
    
    @objc func didPressCigaretteGraphButton() {
        progressView.switchGraphs(nil, .cigarette)
    }
    
    //MARK: SUPPORT FUNC
    
    private func switchRecalculateGraphData(_ newValue: Int, _ type: Any, _ annotation: String) {
        switch type {
        case ProgressType.money:
            guard let currentGraphSetups = progressView.moneyGraphView.getCurrentGraphSetups() else {return}
            guard let countGraphSetup = (currentGraphSetups.filter {$0.annotation == annotation}).first else {return}
            progressDelegate.recalculateGraphData(newValue: newValue, GraphData(setup: countGraphSetup, progress: .money))
        case ProgressType.cigarette:
            guard let currentGraphSetups = progressView.cigaretteGraphView.getCurrentGraphSetups() else {return}
            guard let countGraphSetup = (currentGraphSetups.filter {$0.annotation == annotation}).first else {return}
            progressDelegate.recalculateGraphData(newValue: newValue, GraphData(setup: countGraphSetup, progress: .cigarette))
        default:
            return
        }
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
    func showUpdatedGraph(_ data: GraphData) {
        switch data.progress {
        case .money:
            progressView.moneyGraphView.updateGraph(data.setup)
        case .cigarette:
            progressView.cigaretteGraphView.updateGraph(data.setup)
        default:
            return
        }
    }
    
    func showUserData(_ data: UserData) {
        if let imageData = data.image as Data? {
            if let image = UIImage(data: imageData){
                progressView.userImageView.setImage(image: image)
            }
        }
        
        progressView.moneyBankPicker.setCountValue(data.moneyProgress.bank)
        progressView.cigaretteBankPicker.setCountValue(data.cigaretteProgress.bank)
        
        
        progressView.moneyNormPicker.setNormValue(data.moneyProgress.norm.last!)
        progressView.cigaretteNormPicker.setNormValue(data.cigaretteProgress.norm.last!)
        

        progressView.switchGraphs([GraphSetup(points: data.moneyProgress.count, color: UIColor(white: 0.8, alpha: 0.9), annotation: ProgressViewControllerString.countGraphAnnotation.rawValue), GraphSetup(points: data.moneyProgress.norm, color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: ProgressViewControllerString.normGraphAnnotation.rawValue)], .money)
        
        progressView.cigaretteGraphView.setGraphs([GraphSetup(points: data.cigaretteProgress.count, color: UIColor(white: 0.8, alpha: 0.9), annotation: ProgressViewControllerString.countGraphAnnotation.rawValue), GraphSetup(points: data.cigaretteProgress.norm, color: UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.9), annotation: ProgressViewControllerString.normGraphAnnotation.rawValue)])
        
    }
}

extension ProgressViewController: UICountPickerDelegate {
    func didCountValueChanged(_ newValue: Int, _ type: Any) {
        switchRecalculateGraphData(newValue, type, ProgressViewControllerString.countGraphAnnotation.rawValue)
    }
}

extension ProgressViewController: UINormPickerDelegate {
    func didNormValueChanged(_ newValue: Int, _ type: Any) {
        switchRecalculateGraphData(newValue, type, ProgressViewControllerString.normGraphAnnotation.rawValue)
    }
}
