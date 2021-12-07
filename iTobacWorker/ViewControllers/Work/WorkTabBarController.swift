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
        workTabBar.infoButton.addTarget(self, action: #selector(didPressInfoButton), for: .touchUpInside)
        workTabBar.searchButton.addTarget(self, action: #selector(didPressSearchButton), for: .touchUpInside)
        workTabBar.progressButton.addTarget(self, action: #selector(didPressProgressButton), for: .touchUpInside)
    }
    
    //MARK: SUPPORT FUNC
    
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
}


