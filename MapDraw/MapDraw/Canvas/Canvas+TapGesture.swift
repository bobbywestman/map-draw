//
//  Canvas+TapGesture.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/25/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension Canvas {
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        tapDetected(tapLocation: recognizer.location(in: self))
    }
    
    private func tapDetected(tapLocation:CGPoint) {
        switch drawingState {
        case .line:
            _ = drawLinePoint(tapLocation)
        case .pin:
            drawPin(tapLocation)
        case .none:
            toggleSelection(tapLocation)
        default:
            break
        }
    }
}
