//
//  AbbreviationLabel.swift
//  iTobacWorker
//
//  Created by Nikolas on 14.11.2021.
//

import Foundation
import UIKit
import Dispatch

final class AbbreviationLabel: UIView {
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    //MARK: INTERNAL FUNC
    
    
    
    //MARK: drawAbbreviation
    func drawAbbreviation() {
        let stringAttributes = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 38.5)!]
        let attributedString = NSMutableAttributedString(string: "iTobacWorker", attributes: stringAttributes )
        let charPaths = self.getCharacterPaths(attributedString: attributedString, position: CGPoint(x: 7, y: 60))

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
    
    //MARK: PRIVATE UI
    
    
    
    //MARK: imageView
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cigarette.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.alpha = 0
        return imageView
    }()
    
}

//MARK: PRIVATE UI FUNC
private extension AbbreviationLabel {
    
    
    //MARK: CONSTRAINTS
    
    
    
    //MARK: constraintsImageView
    func constraintsImageView() {
        imageView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerX.equalTo(self.snp.centerX).offset(-22)
            make.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }
    
    //MARK: SUPPORT FUNC
    
    
    
    //MARK: makeUI
    func makeUI() {
        self.addSubview(imageView)
        constraintsImageView()
    }
    
    //MARK: getCharacterPaths
    func getCharacterPaths(attributedString: NSAttributedString, position: CGPoint) -> [CGPath] {

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
    
    //MARK: animateToAbbreviation
    func animateToAbbreviation(_ charLayers: [CAShapeLayer]) {
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
}

//MARK: DELEGATE EXTENSION
extension AbbreviationLabel:CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        UIView.animate(withDuration: 1){[weak self] in
            guard let self = self else{return}
            self.imageView.alpha = 1
        }
    }
}
