//
//  BrandsViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 29.01.2022.
//

import UIKit


//MARK: STRING

private enum BrandsViewString: String {
    case collectionCellIdentifier = "CollectionViewCellIdentifier"
}

// MARK: CONTANTS

enum Constants {

    static let cellSpacing: CGFloat = 8
}

// MARK: DELEGATE

protocol BrandsViewDelegate: AnyObject{
    
}


class BrandsViewController: UIViewController
{
    var brandsView: BrandsView!
    var brandsPresenter: BrandsParseDelegate!
    
    var selectedCell: CollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    var animator: Animator?
    
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
        brandsView = BrandsView()
        brandsPresenter = BrandsPresenter(delegate: self)
        
        brandsView.collectionView.delegate = self
        brandsView.collectionView.dataSource = self
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view = brandsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        brandsPresenter.parseBrandsFromFolder()
    }
    
    // MARK: SUPPORT FUNC
    
    func presentSingleBrandViewController(with data: Brand) {
        let singleBrandViewController = SingleBrandViewController()

        singleBrandViewController.transitioningDelegate = self
        singleBrandViewController.modalPresentationStyle = .fullScreen
        singleBrandViewController.brand = data
        
        present(singleBrandViewController, animated: true)
    }

}

//MARK: DELEGATE EXTENSION

extension BrandsViewController: BrandsViewDelegate {
    
}

extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandsPresenter.getBrandsCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: BrandsViewString.collectionCellIdentifier.rawValue)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandsViewString.collectionCellIdentifier.rawValue, for: indexPath) as! CollectionViewCell
        if let brand = brandsPresenter.getBrandByIndex(at: indexPath.row) {
            cell.configure(with: brand)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        selectedCellImageViewSnapshot = selectedCell?.brandImageView.snapshotView(afterScreenUpdates: false)
        if let brand = brandsPresenter.getBrandByIndex(at: indexPath.row) {
            presentSingleBrandViewController(with: brand)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Constants.cellSpacing) / 2
        return .init(width: width, height: width)
    }
}

extension BrandsViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? BrandsViewController,
            let secondViewController = presented as? SingleBrandViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let secondViewController = dismissed as? SingleBrandViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}
