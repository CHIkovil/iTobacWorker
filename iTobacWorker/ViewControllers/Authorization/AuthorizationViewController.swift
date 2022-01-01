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

    }
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        authorizationView = AuthorizationView()
        authorizationView.appLabel.delegate = self
        self.view = authorizationView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authorizationView.appLabel.showAbbreviation()
    }
}

//MARK: DELEGATE EXTENSION

extension AuthorizationViewController: AbbreviationDelegate{
    func animateEnd() {
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let self = self else{return}
            self.authorizationView.appLabel.transform.ty = -113
        }, completion: { [weak self] _ in
            guard let self = self else{return}
            UIView.animate(withDuration: 0.5,animations: {[weak self] in
                guard let self = self else{return}
                self.authorizationView.boardView.alpha = 1
                self.authorizationView.loginTextField.showInputField()
            },completion: {[weak self] _ in
                guard let self = self else{return}
                self.authorizationView.appLabel.showSmoke()
            })
        })
    }
}

