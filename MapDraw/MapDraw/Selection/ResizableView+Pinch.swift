//
//  ResizableView+Pinch.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/23/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ResizableView {
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        let pinchScale: CGFloat = recognizer.scale
        transform = transform.scaledBy(x: pinchScale, y: pinchScale)
        recognizer.scale = 1.0
    }
}
