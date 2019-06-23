//
//  CGHelper.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

class CGHelper {
    static func maxDistance() -> CGFloat {
        return CGFloat.greatestFiniteMagnitude
    }
    
    static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
}

/// Creates a border around the *outside* of a UIView
/// This is useful for the selection view, since a screenshot is captured of the view to draw on, we dont want the border to be captured as part of the screenshot
///
/// adapted from source: https://stackoverflow.com/a/35756672
extension UIView {
    
    struct Constants {
        static let ExternalBorderName = "externalBorder"
    }
    
    func addExternalBorder(_ width: CGFloat = 2.0, _ color: UIColor = .white) {
        let externalBorder = CALayer()
        externalBorder.frame = CGRect(x: -width, y: -width, width: frame.size.width + 2 * width, height: frame.size.height + 2 * width)
        externalBorder.borderColor = color.cgColor
        externalBorder.borderWidth = width
        externalBorder.name = Constants.ExternalBorderName
        
        layer.insertSublayer(externalBorder, at: 0)
        layer.masksToBounds = false
    }
    
    func removeExternalBorders() {
        layer.sublayers?.filter() { $0.name == Constants.ExternalBorderName }.forEach() {
            $0.removeFromSuperlayer()
        }
    }
    
    func removeExternalBorder(externalBorder: CALayer) {
        guard externalBorder.name == Constants.ExternalBorderName else { return }
        externalBorder.removeFromSuperlayer()
    }
}
