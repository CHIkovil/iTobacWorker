//
//  CollectionViewCell.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.02.2022.
//

import Foundation
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeLayer()
    }
    
    //MARK: UI
    
    lazy var brandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AppString.fontName.rawValue, size: 20)
        label.textColor = .black
        return label
    }()
    
    //MARK: CONSTRAINTS
    
    func constraintsBrandImageView() {
        brandImageView.snp.makeConstraints {(make) -> Void in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    func constraintsBrandLabel() {
        brandLabel.snp.makeConstraints {(make) -> Void in
            make.center.equalTo(contentView.snp.center)
            make.width.equalTo(contentView.bounds.width * 0.7)
            make.height.equalTo(contentView.bounds.width * 0.3)
        }
    }
    

    //MARK: SUPPORT FUNC
    
    func configure(with cellData: Brand) {
        brandImageView.image = cellData.image
        brandLabel.text = cellData.title
    }
    
    func makeUI() {
        contentView.addSubview(brandImageView)
        contentView.addSubview(brandLabel)
        
        constraintsBrandImageView()
        constraintsBrandLabel()
    }
    
    func makeLayer(){
        let color = #colorLiteral(red: 0.1126094386, green: 0.1120074913, blue: 0.1353533268, alpha: 1)
        contentView.layer.drawBlockLayer(cornerWidth: 25,color: color)
        contentView.layer.drawBorder(25)
    }
}


