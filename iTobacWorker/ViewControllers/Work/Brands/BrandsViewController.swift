//
//  BrandsViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 29.01.2022.
//

import UIKit

// MARK: DELEGATE

protocol BrandsViewDelegate: AnyObject{
  
}


class BrandsViewController: UIViewController
{
    var brandsView: BrandsView!
    var brandsPresenter: BrandsDelegate!
    
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
        brandsPresenter = BrandsPresenter(delegate: self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

}

//MARK: DELEGATE EXTENSION

extension BrandsViewController: BrandsViewDelegate {
    
}
