//
//  BrandsView.swift
//  iTobacWorker
//
//  Created by Nikolas on 29.01.2022.
//

import Foundation
import UIKit

//MARK: CONSTANTS

private enum BrandViewConstants {
    static let collectionViewSide = 300
    
}

class BrandsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.cellSpacing
        layout.minimumInteritemSpacing = Constants.cellSpacing
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.bounces = true
        view.layer.cornerRadius = 20
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    //MARK: CONSTRAINTS
    
    func constraintsCollectionView() {
        collectionView.snp.makeConstraints {(make) -> Void in
            make.center.equalTo(self.snp.center)
            make.height.equalTo(BrandViewConstants.collectionViewSide)
            make.width.equalTo(BrandViewConstants.collectionViewSide)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        self.backgroundColor = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        
        self.addSubview(collectionView)
        constraintsCollectionView()
    }
}
