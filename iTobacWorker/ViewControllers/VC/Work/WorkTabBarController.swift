//
//  WorkTabBarController.swift
//  iTobacWorker
//
//  Created by Nikolas on 02.12.2021.
//

import Foundation
import UIKit

// MARK: STRING

private enum WorkTabBarControllerString: String {
    case valueKey = "tabBar"
}

class WorkTabBarController: UITabBarController {
    
    var workTabBar: UIWorkTabBar!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        
        workTabBar.infoButton.addTarget(self, action: #selector(didPressInfoButton), for: .touchUpInside)
        workTabBar.searchButton.addTarget(self, action: #selector(didPressSearchButton), for: .touchUpInside)
        workTabBar.progressButton.addTarget(self, action: #selector(didPressProgressButton), for: .touchUpInside)
        
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeViewController)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        workTabBar.selectItem(at: selectedIndex)
    }
    
    //MARK: SUPPORT FUNC
    
    func makeUI(){
        let tabBar = UIWorkTabBar()
        self.workTabBar = tabBar
        self.setValue(tabBar, forKey: WorkTabBarControllerString.valueKey.rawValue)
        
        let brandsViewController = BrandsViewController()
        
        let middleVC = UIViewController()
        middleVC.view.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        
        let progressViewController = ProgressViewController()
        
        viewControllers = [brandsViewController, middleVC, progressViewController]
    }
    
    // MARK: OBJC
    
    @objc func didPressInfoButton() {
        selectedIndex = 0
        workTabBar.selectItem(at: 0)
    }
    
    @objc func didPressSearchButton() {
        selectedIndex = 1
        workTabBar.selectItem(at: 1)
    }
    
    @objc func didPressProgressButton() {
        selectedIndex = 2
        workTabBar.selectItem(at: 2)
    }
    
    @objc func swipeViewController(_ sender: UIPanGestureRecognizer){
        if sender.state == .ended {
            let velocity = sender.velocity(in: self.view)
            if (velocity.x < 0) {
                selectedIndex += 1
                
            } else {
                selectedIndex -= 1
            }
            workTabBar.selectItem(at: selectedIndex)
        }
    }
}


