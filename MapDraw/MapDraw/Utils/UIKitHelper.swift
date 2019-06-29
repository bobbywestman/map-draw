//
//  UIKitHelper.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/27/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func blur(_ style: UIBlurEffect.Style = .extraLight, intensity: CGFloat) {
        let blurEffect = UIBlurEffect(style: style)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.alpha = intensity
        addSubview(blur)

        blur.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blur.leftAnchor.constraint(equalTo: leftAnchor),
            blur.topAnchor.constraint(equalTo: topAnchor),
            blur.rightAnchor.constraint(equalTo: rightAnchor),
            blur.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// source: https://stackoverflow.com/a/30713456/11687264
extension UIColor {
    var hsba:(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
}

// adapted from source: https://stackoverflow.com/a/40561499/11687264
extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return img
    }
}
