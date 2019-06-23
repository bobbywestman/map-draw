//
//  ViewController+Selection.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation

extension ViewController {
    @IBAction func selectButtonClick(_ sender: Any) {
        if selectorView.isHidden {
            // show the selector view
            selectorView.isHidden = false
        } else {
            // select highlighted portion of the map
            
            let screenshot = ScreenshotHelper.screenshot(of: view, in: selectorView.frame)
            selectionImageView.image = screenshot
            selectionImageView.isHidden = false

            interactionState = .drawing
        }
    }
}
