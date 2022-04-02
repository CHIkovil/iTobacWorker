//
//  AuthorizationViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import UIKit

class AuthorizationViewController: UIViewController
{
    var authorizationView: AuthorizationView!
    
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
        authorizationView = AuthorizationView()
        
        
    }
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view = authorizationView
        
        authorizationView.appLabel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorizationView.appLabel.showAbbreviation()
    }
}

//MARK: DELEGATE EXTENSION

extension AuthorizationViewController: UIAbbreviationDelegate{
    func didEndedAnimation() {
        authorizationView.showInputBoard()
    }
}

