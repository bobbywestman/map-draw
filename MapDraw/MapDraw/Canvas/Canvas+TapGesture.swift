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
            guard let pin = hitTestForTappingPin(tapLocation) else {
                _ = drawPin(tapLocation)
                break
            }
            selectPin(pin)
        case .none:
            toggleSelection(tapLocation)
        default:
            break
        }
    }
}

extension Canvas {
    
    // TODO: rename this better and delete duplicate `hitTestForPanningPin`
    func hitTestForTappingPin(_ location:CGPoint) -> Pin? {
        var closestPinInThreshold: Pin?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for pin in pins {
            // Compare distance using the pin's image center, instead of the pin `location`.
            // Even though the `location` of the pin is at the bottom center of the image / marker, the user will more likely drag the image itself to try to move the pin
            let pinImageCenter = calculatePinImageCenter(pin)
            
            let distance = CGHelper.distance(location, pinImageCenter)
            guard distance < Canvas.kPinTapThreshold else { continue }
            
            if distance < closestDistance {
                closestDistance = distance
                closestPinInThreshold = pin
            }
        }
        
        return closestPinInThreshold
    }
}

