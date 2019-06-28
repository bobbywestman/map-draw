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
