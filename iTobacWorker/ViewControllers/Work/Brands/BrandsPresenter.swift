//
//  BrandsPresenter.swift
//  iTobacWorker
//
//  Created by Nikolas on 29.01.2022.
//

import UIKit

// MARK: DELEGATE

protocol BrandsDelegate: AnyObject{
    
}

class BrandsPresenter
{
    
  weak var brandsViewDelegate: BrandsViewDelegate?
  
    init(delegate:BrandsViewDelegate){
        self.brandsViewDelegate = delegate
    }
 
}

// MARK: BrandsDelegate

extension BrandsPresenter: BrandsDelegate {
    
}
