//
//  ViewController+Screenshot.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    @IBAction func saveButtonClick(_ sender: Any) {
        let screenshot = view.screenshot(of: selectionImageView.frame)
        
        let screenshotView = UIImageView(image: screenshot)
        screenshotView.translatesAutoresizingMaskIntoConstraints = false
        
        let alert = UIAlertController(title: "Save Screenshot", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { (action) in
            ScreenshotHelper.saveImageToCameraRoll(screenshot)
        })
        alert.view.addSubview(screenshotView)
        
        // TODO: revisit this.. possibly create a custom alert vc
        // calculate height
        let height = CGFloat(125)
        // calculate aspect ratio of map
        let ratio = CGHelper.aspectRatio(width: selectionImageView.frame.width, height: selectionImageView.frame.height) 
        // calculate width
        let width = ratio * height
        
        NSLayoutConstraint.activate([
            screenshotView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            screenshotView.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor),
            screenshotView.heightAnchor.constraint(equalToConstant: height),
            screenshotView.widthAnchor.constraint(equalToConstant: width),
            ])
        present(alert, animated: true, completion: nil)
    }
}
