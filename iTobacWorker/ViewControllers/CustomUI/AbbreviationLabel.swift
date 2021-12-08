//
//  AbbreviationLabel.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import Dispatch

protocol AbbreviationDelegate: class {
    func animationDidEnd()
}

final class AbbreviationLabel: UIView {
    
    weak var delegate: AbbreviationDelegate?
    
    // MARK: draw
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: showAbbreviation
    func showAbbreviation() {
        let stringAttributes = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 45)!]
        let attributedString = NSMutableAttributedString(string: "iTobacWorker", attributes: stringAttributes )
        let charPaths = self.getCharacterPaths(attributedString: attributedString, position: CGPoint(x: -10, y: 60))

        let charLayers = charPaths.map { path -> CAShapeLayer in
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.path = path
            return shapeLayer
        }
        
        animateToAbbreviation(charLayers)
    }
    
    //MARK: animateSmokeImage
    func animateSmokeImage(){
        UIView.animate(withDuration: 2){[weak self] in
            guard let self = self else{return}
            self.smokeImageView.alpha = 0.8
        }
    }
 
    //MARK: PRIVATE
    
    
    
    //MARK: UI
    
    
    
    private lazy var cigaretteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cigarette"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var smokeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "smoke"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0
        return imageView
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsCigaretteImageView() {
        cigaretteImageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerX.equalTo(self.snp.centerX).offset(-22)
            make.bottom.equalTo(self.snp.bottom).offset(-6.5)
        }
    }
    
   private func constraintsSmokeImageView() {
        smokeImageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(cigaretteImageView.snp.centerX).offset(-9)
            make.bottom.equalTo(cigaretteImageView.snp.top).offset(8)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI() {
        self.addSubview(cigaretteImageView)
        self.addSubview(smokeImageView)
        
        constraintsCigaretteImageView()
        constraintsSmokeImageView()
    }
    
    private func getCharacterPaths(attributedString: NSAttributedString, position: CGPoint) -> [CGPath] {

        let line = CTLineCreateWithAttributedString(attributedString)

        guard let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return []}

        var characterPaths = [CGPath]()

        for glyphRun in glyphRuns {
            guard let attributes = CTRunGetAttributes(glyphRun) as? [String:AnyObject] else { continue }
            let font = attributes[kCTFontAttributeName as String] as! CTFont

            for index in 0..<CTRunGetGlyphCount(glyphRun) {
                let glyphRange = CFRangeMake(index, 1)

                var glyph = CGGlyph()
                CTRunGetGlyphs(glyphRun, glyphRange, &glyph)

                var characterPosition = CGPoint()
                CTRunGetPositions(glyphRun, glyphRange, &characterPosition)
                characterPosition.x += position.x
                characterPosition.y += position.y

                if let glyphPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y)
                    if let charPath = glyphPath.copy(using: &transform) {
                        characterPaths.append(charPath)
                    }
                }
            }
        }
        return characterPaths
    }

    //MARK: ANIMATION
    
    private func animateToAbbreviation(_ charLayers: [CAShapeLayer]) {
        for (index,layer) in charLayers.enumerated(){
            self.layer.addSublayer(layer)
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1
            animation.toValue = 0
            animation.fillMode = .forwards;
            animation.isRemovedOnCompletion = false;
        
            let layersLength = charLayers.count
            switch index {
            case layersLength / 2 - 1:
                animation.delegate = self
                fallthrough
            case 0...layersLength / 2 - 2:
                animation.duration = CFTimeInterval(index + 1)
            case layersLength / 2 + 1...layersLength - 1:
                animation.duration = CFTimeInterval(layersLength - index + 1)
            case layersLength / 2:
                continue
            default:
                break
            }
            layer.add(animation, forKey: "charAnimation")
        }
    }
    
    private func animateCigaretteImage(){
        UIView.animate(withDuration: 2, animations: {[weak self] in
            guard let self = self else{return}
            self.cigaretteImageView.alpha = 1
        }, completion: { [weak self] _ in
            guard let self = self else{return}
            guard let delegate = self.delegate else{return}
            delegate.animationDidEnd()
        })
    }
    
}

//MARK: DELEGATE EXTENSION

extension AbbreviationLabel:CAAnimationDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animateCigaretteImage()
    }
}
