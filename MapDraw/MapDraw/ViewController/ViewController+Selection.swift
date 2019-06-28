//
//  ViewController+Selection.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func selectImage(_ image: UIImage) {
        selectionImageView.image = image
        // selectionImageView.height = image.height
        interactionState = .drawing
    }
    
    @IBAction func selectButtonClick(_ sender: Any) {
        if selectorView.isHidden {
            // show the selector view
            resetSelectorPosition()
            selectorView.isHidden = false
        } else {
            // select highlighted portion of the map
            
            let screenshot = ScreenshotHelper.screenshot(of: view, in: selectorView.frame)
            selectImage(screenshot)
        }
    }
    
    func resetSelectorPosition() {
        guard let map = self.map, let selectorView = self.selectorView else { return }
        
        let aspectRatio = CGHelper.aspectRatio(width: map.frame.width, height: map.frame.height)
        let height = map.frame.height / 3
        
        selectorView.removeExternalBorders()
        selectorView.transform = .identity
        selectorView.frame = CGRect(x: 0, y: 0, width: height * aspectRatio, height: height)
        selectorView.aspectRatio = aspectRatio
        selectorView.center = map.center
        selectorView.addExternalBorder(5.0, .white)
    }
}
