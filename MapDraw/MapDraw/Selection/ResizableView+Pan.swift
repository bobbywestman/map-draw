//
//  ResizableView+Pan.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/23/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ResizableView {
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: container ?? self)
        
        if recognizer.state == .began {
            if topLeftCorner.contains(location) {
                panning = .topLeft
            } else if topRightCorner.contains(location) {
                panning = .topRight
            } else if bottomLeftCorner.contains(location) {
                panning = .bottomLeft
            } else if bottomRightCorner.contains(location) {
                panning = .bottomright
            } else {
                panning = .center
            }
        } else if recognizer.state == .ended {
            panning = nil
        }
        
        guard let panning = panning, let container = container else {
            return
        }
        
        switch panning {
        case .center:
            // translate view while dragging
            let translation = recognizer.translation(in: container)
            center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero , in: container)
        case .topLeft:
            // resize view while dragging corner
            
            // TODO: impl
            print("left")
        case .topRight:
            // resize view while dragging corner
            
            // TODO: impl
            print("right")
        case .bottomright:
            // resize view while dragging corner
            
            // TODO: impl
            print("bottomRight")
        case .bottomLeft:
            // resize view while dragging corner
            
            // TODO: impl
            print("bottomLeft")
        }
    }
}
