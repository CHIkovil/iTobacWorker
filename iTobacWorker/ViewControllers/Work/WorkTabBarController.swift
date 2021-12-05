//
//  WorkTabBarController.swift
//  iTobacWorker
//
//  Created by Nikolas on 02.12.2021.
//

import Foundation
import UIKit

class WorkTabBarController: UITabBarController {
    
    var workTabBar: WorkTabBar!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        workTabBar.infoButton.addTarget(self, action: #selector(didPressInfoButton), for: .touchUpInside)
        workTabBar.searchButton.addTarget(self, action: #selector(didPressMiddleButton), for: .touchUpInside)
        workTabBar.progressButton.addTarget(self, action: #selector(didPressProgressButton), for: .touchUpInside)
    }
}

//MARK: PRIVATE UI FUNC
private extension WorkTabBarController {
    
    // MARK: makeUI
    func makeUI(){
        let tabBar = WorkTabBar()
        self.workTabBar = tabBar
        self.setValue(tabBar, forKey: "tabBar")
        
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        
        let middleVC = UIViewController()
        middleVC.view.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        
        let secondVC = UIViewController()
        secondVC.view.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)

        
        viewControllers = [firstVC, middleVC, secondVC]
    }
    
    // MARK: OBJC
    
    
    
    // MARK: didPressInfoButton
    @objc func didPressInfoButton() {
        selectedIndex = 0
    }
    
    // MARK: didPressMiddleButton
    
    @objc func didPressMiddleButton() {
        selectedIndex = 1
        workTabBar.searchButton.animateWakeUp()
    }
    
    // MARK: didPressProgressButton
    @objc func didPressProgressButton() {
        selectedIndex = 2
    }
}

//MARK: PRIVATE UI EXTENSION
private extension UIButton{
    
    //MARK: animateWakeUp
    func animateWakeUp(){
        UIView.animate(withDuration: 0.2,
                       animations: {[weak self] in
            guard let self = self else{return}
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: {  _ in
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self = self else{return}
                self.transform = CGAffineTransform.identity
                
            }
            
        })
    }
    
}

