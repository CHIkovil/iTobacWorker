//
//  BrandsPresenter.swift
//  iTobacWorker
//
//  Created by Nikolas on 29.01.2022.
//

import Foundation
import UIKit

// MARK: DELEGATE

protocol BrandsParseDelegate: AnyObject{
    func parseBrandsFromFolder()
    func getBrandByIndex(at index: Int) -> Brand?
    func getBrandsCount() -> Int?
}

class BrandsPresenter
{
    
    weak var brandsViewDelegate: BrandsViewDelegate?
    var brands: [Int: Brand]?
    
    init(delegate:BrandsViewDelegate){
        self.brandsViewDelegate = delegate
    }
    
}

// MARK: BrandsParseDelegate

extension BrandsPresenter: BrandsParseDelegate {
    func getBrandsCount() -> Int? {
        guard let brands = self.brands else{return nil}
        return brands.count
    }
    
    func parseBrandsFromFolder() {
        let imageUrls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "Brands")!.sorted{$0.deletingPathExtension().lastPathComponent < $1.deletingPathExtension().lastPathComponent}
        var brands = [Int: Brand]()
        
        
        for index in 1...imageUrls.count - 1 {
            guard let data = NSData(contentsOf: imageUrls[index]) as Data? else{return}
            guard let image = UIImage(data: data) else{return}
            let brandName = imageUrls[index].deletingPathExtension().lastPathComponent
            brands[index] = Brand(image: image, title: brandName)
        }
        self.brands = brands
    }
    
    func getBrandByIndex(at index: Int) -> Brand? {
        guard let brands = self.brands else{return nil}
        return brands[index]
    }
    
}
