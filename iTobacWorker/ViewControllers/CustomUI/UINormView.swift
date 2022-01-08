//
//  UINormView.swift
//  iTobacWorker
//
//  Created by Nikolas on 08.01.2022.
//

import Foundation
import UIKit

final class UINormView: UIView {
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: SUPPORT FUNC
    
    private func makeUI(){
        self.layer.drawBlockLayer(cornerWidth: 25,color: #colorLiteral(red: 0.1261322796, green: 0.1471925974, blue: 0.2156360745, alpha: 0.6))
    }
}
