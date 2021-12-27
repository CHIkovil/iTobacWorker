//
//  GraphView.swift
//  iTobacWorker
//
//  Created by Nikolas on 27.12.2021.
//

import Foundation
import UIKit

final class GraphView: UIView {
    
    override func draw(_ rect: CGRect) {
        makeUI()
    }
    
    //MARK: SUPPORT FUNC
    private func makeUI(){
        self.layer.drawBlockLayer(cornerWidth: 25)
    }
}
