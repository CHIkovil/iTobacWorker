//
//  Animator.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.02.2022.
//

import Foundation
import UIKit

enum PresentationType {

    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    static let duration: TimeInterval = 1
    
    private let type: PresentationType
    private let brandsViewController: BrandsViewController
    private let singleBrandViewController: SingleBrandViewController
    
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect
    private let cellLabelRect: CGRect

    init?(type: PresentationType, firstViewController: BrandsViewController, secondViewController: SingleBrandViewController, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        self.brandsViewController = firstViewController
        self.singleBrandViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window,
            let selectedCell = firstViewController.selectedCell
            else { return nil }

        self.cellImageViewRect = selectedCell.brandImageView.convert(selectedCell.brandImageView.bounds, to: window)

        self.cellLabelRect = selectedCell.brandLabel.convert(selectedCell.brandLabel.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = singleBrandViewController.view
            else {
                transitionContext.completeTransition(false)
                return
        }

        containerView.addSubview(toView)

        guard
            let selectedCell = brandsViewController.selectedCell,
            let window = brandsViewController.view.window ?? singleBrandViewController.view.window,
            let cellImageSnapshot = selectedCell.brandImageView.snapshotView(afterScreenUpdates: true),
            let controllerImageSnapshot = singleBrandViewController.singleBrandView.brandImageView.snapshotView(afterScreenUpdates: true),
            let cellLabelSnapshot = selectedCell.brandLabel.snapshotView(afterScreenUpdates: true),
            let closeButtonSnapshot = singleBrandViewController.singleBrandView.closeButton.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(true)
                return
        }

        let isPresenting = type.isPresenting

        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = singleBrandViewController.view.backgroundColor

        if isPresenting {
            selectedCellImageViewSnapshot = cellImageSnapshot

            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = brandsViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }

        toView.alpha = 0

        [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot, cellLabelSnapshot, closeButtonSnapshot].forEach { containerView.addSubview($0) }

        let controllerImageViewRect = singleBrandViewController.singleBrandView.brandImageView.convert(singleBrandViewController.singleBrandView.brandImageView.bounds, to: window)

        let controllerLabelRect = singleBrandViewController.singleBrandView.brandLabel.convert(singleBrandViewController.singleBrandView.brandLabel.bounds, to: window)

        let closeButtonRect = singleBrandViewController.singleBrandView.closeButton.convert(singleBrandViewController.singleBrandView.closeButton.bounds, to: window)

        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
            $0.layer.cornerRadius = isPresenting ? 12 : 0
            $0.layer.masksToBounds = true
        }

        controllerImageSnapshot.alpha = isPresenting ? 0 : 1

        selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0

        cellLabelSnapshot.frame = isPresenting ? cellLabelRect : controllerLabelRect

        closeButtonSnapshot.frame = closeButtonRect
        closeButtonSnapshot.alpha = isPresenting ? 0 : 1

        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect

                fadeView.alpha = isPresenting ? 1 : 0

                cellLabelSnapshot.frame = isPresenting ? controllerLabelRect : self.cellLabelRect

                [controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
                    $0.layer.cornerRadius = isPresenting ? 0 : 12
                }
            }

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: isPresenting ? 0.7 : 0, relativeDuration: 0.3) {
                closeButtonSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { _ in
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()

            backgroundView.removeFromSuperview()
            cellLabelSnapshot.removeFromSuperview()
            closeButtonSnapshot.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}


