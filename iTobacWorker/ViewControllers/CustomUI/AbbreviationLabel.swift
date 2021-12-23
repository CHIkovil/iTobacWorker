//
//  AbbreviationLabel.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import Dispatch

private enum AbbreviationLabelString: String {
    case appName = "iTobacWorker"
    case fontName = "Chalkduster"
    case cigaretteImageName = "cigarette"
    case smokeImageName = "smoke"
    case charAnimationKey = "opacity"
}

//MARK: PROTOCOL

protocol AbbreviationDelegate: AnyObject {
    func animateEnd()
}

final class AbbreviationLabel: UIView {
    
    weak var delegate: AbbreviationDelegate?
    var textSize: CGFloat?
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: showAbbreviation
    func showAbbreviation() {
        let stringAttributes = [ NSAttributedString.Key.font: UIFont(name: AbbreviationLabelString.fontName.rawValue, size: textSize ?? 45)!]
        let attributedString = NSMutableAttributedString(string: AbbreviationLabelString.appName.rawValue, attributes: stringAttributes )
        let charPaths = self.getCharacterPaths(attributedString: attributedString, position: CGPoint(x: -10, y: labelHeight - 10))
        
        let charLayers = charPaths.map { path -> CAShapeLayer in
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            shapeLayer.lineWidth = 2
            shapeLayer.path = path
            return shapeLayer
        }
        charLayers[6].strokeColor = UIColor.lightGray.cgColor
        
        self.layer.addAbbreviationAnimation(delegate: self, charLayers)
    }
    
    //MARK: showSmoke
    func showSmoke(){
        smokeImageView.animateOpacityWithEnding(delegate: nil)
    }
 
    //MARK: PRIVATE
    
    private var labelHeight: CGFloat {self.frame.height}
    
    //MARK: UI
    
    private lazy var cigaretteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: AbbreviationLabelString.cigaretteImageName.rawValue))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var smokeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: AbbreviationLabelString.smokeImageName.rawValue))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0
        return imageView
    }()
    
    //MARK: CONSTRAINTS
    
    private func constraintsCigaretteImageView() {
        cigaretteImageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(labelHeight * 0.57)
            make.height.equalTo(labelHeight * 0.57)
            make.centerX.equalTo(self.snp.centerX).offset(-22)
            make.bottom.equalTo(self.snp.bottom).offset(-6.5)
        }
    }
    
   private func constraintsSmokeImageView() {
        smokeImageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(labelHeight * 0.71)
            make.height.equalTo(labelHeight * 0.71)
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
}

//MARK: UI ANIMATION EXTENSION

private extension CALayer {

    func addAbbreviationAnimation(delegate: CAAnimationDelegate,_ charLayers: [CAShapeLayer]) {
        for (index,shapeLayer) in charLayers.enumerated(){
            self.addSublayer(shapeLayer)
            let animation = CABasicAnimation(keyPath: AbbreviationLabelString.charAnimationKey.rawValue)
            animation.fromValue = 1
            animation.toValue = 0
            animation.fillMode = .forwards;
            animation.isRemovedOnCompletion = false;
        
            let layersLength = charLayers.count
            
            switch index {
            case layersLength / 2 - 1:
                animation.delegate = delegate
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
            
            shapeLayer.add(animation, forKey: AbbreviationLabelString.charAnimationKey.rawValue)
        }
    }
}

private extension UIView {
    func animateOpacityWithEnding(delegate: AbbreviationDelegate?){
        UIView.animate(withDuration: 2, animations: {[weak self] in
            guard let self = self else{return}
            self.alpha = 0.8
        }, completion: { _ in
            guard let delegate = delegate else {return}
            delegate.animateEnd()
        })
    }
}

//MARK: DELEGATE EXTENSION

extension AbbreviationLabel:CAAnimationDelegate{

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        cigaretteImageView.animateOpacityWithEnding(delegate: delegate)
    }
}
