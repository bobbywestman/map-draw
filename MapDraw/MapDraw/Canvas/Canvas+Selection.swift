//
//  Canvas+Selection.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/25/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension Canvas {
    /// Used to handle selection of a path
    func toggleSelection(_ tapLocation:CGPoint) {
        var hitDetected = false
        
        if didSelectPin(tapLocation) {
            hitDetected = true
        }
        
        if !hitDetected {
            if didSelectLine(tapLocation) {
                hitDetected = true
            }
        }
        
        if !hitDetected {
            // if no elements tapped, deselect currently selected elements
            deselect()
        }
    }
    
    func didSelectPin(_ tapLocation:CGPoint) -> Bool {
        for pin in pins {
            if CGHelper.distance(tapLocation, pin.location) < Canvas.kPinTapThreshold {
                if pin == selectedPin {
                    // deselect pin
                    selectedPin = nil
                } else {
                    // select pin
                    selectedPin = pin
                    drawColor = pin.color
                    
                    // pin was selected
                    return true
                }
            }
        }
        return false
    }
    
    func didSelectLine(_ tapLocation:CGPoint) -> Bool {
        for line in lines {
            // verify path exists, some lines have 0 or 1 points
            guard let path = line.path else {
                continue
            }
            
            // we need to copy the path, to hit test inside the entire drawn stroke
            let pathCgCopy = path.cgPath.copy(strokingWithWidth: Canvas.kLineTapThreshold, lineCap: path.lineCapStyle, lineJoin: path.lineJoinStyle, miterLimit: path.miterLimit)
            let lineHitPath = UIBezierPath(cgPath: pathCgCopy)
            if lineHitPath.contains(tapLocation) {
                if line == selectedLine {
                    // deselect line
                    selectedLine = nil
                } else {
                    // select line
                    selectedLine = line
                    drawColor = line.color
                    
                    // line was selected
                    return true
                }
            }
        }
        return false
    }
}
