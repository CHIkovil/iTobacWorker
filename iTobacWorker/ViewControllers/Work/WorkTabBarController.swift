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
}

//MARK: PRIVATE UI FUNC
private extension WorkTabBarController {
    
    
    //MARK: SUPPORT FUNC
    
    
    
    // MARK: makeUI
    func makeUI(){
        let tabBar = WorkTabBar()
        self.setValue(tabBar, forKey: "tabBar")
        self.workTabBar = tabBar
        
        workTabBar.infoButton.addTarget(self, action: #selector(didPressInfoButton), for: .touchUpInside)
        workTabBar.searchButton.addTarget(self, action: #selector(didPressMiddleButton), for: .touchUpInside)
        workTabBar.progressButton.addTarget(self, action: #selector(didPressProgressButton), for: .touchUpInside)
        
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        
        let middleVC = UIViewController()
        middleVC.view.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        
        let secondVC = UIViewController()
        secondVC.view.backgroundColor = #colorLiteral(red: 0.2118592262, green: 0.2122503817, blue: 0.2306241989, alpha: 1)
        
        
        viewControllers = [firstVC, middleVC, secondVC]
    }
    
    // MARK: deselectItemsColor
    func deselectItemsColor(){
        for button in self.tabBar.subviews{
            button.animateDeselect()
        }
    }
    
    // MARK: OBJC
    
    
    
    // MARK: didPressInfoButton
    @objc func didPressInfoButton() {
        deselectItemsColor()
        selectedIndex = 0
        workTabBar.infoButton.animateSelect()
    }
    
    // MARK: didPressMiddleButton
    @objc func didPressMiddleButton() {
        deselectItemsColor()
        selectedIndex = 1
        workTabBar.searchButton.animateSelect()
        workTabBar.searchButton.animateWakening()
    }
    
    // MARK: didPressProgressButton
    @objc func didPressProgressButton() {
        deselectItemsColor()
        selectedIndex = 2
        workTabBar.progressButton.animateSelect()
    }
}

//MARK: PRIVATE UI EXTENSION
private extension UIView{
    
    //MARK: animateWakening
    func animateWakening(){
        UIView.animate(withDuration: 0.2,
                       animations: {[weak self] in
            guard let self = self else{return}
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        },
                       completion: {  _ in
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self = self else{return}
                self.transform = CGAffineTransform.identity
                
            }
            
        })
    }
    
    //MARK: animateSelect
    func animateSelect(){
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self = self else{return}
            self.layer.borderColor = #colorLiteral(red: 0.6985495687, green: 0.6986688375, blue: 0.6985339522, alpha: 1).cgColor
        }
    }
    
    //MARK: animateDeselect
    func animateDeselect(){
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self = self else{return}
            self.layer.borderColor = #colorLiteral(red: 0.1395464242, green: 0.1398070455, blue: 0.1519106925, alpha: 1).cgColor
        }
    }
}
