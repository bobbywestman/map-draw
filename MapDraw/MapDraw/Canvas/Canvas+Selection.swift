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
    func deselectAll() {
        selectedLine = nil
        selectedPin = nil
        selectedText = nil
        
        hidePinOverlay()
    }
    
    func selectPin(_ pin: Pin) {
        selectedPin = pin
        showPinOverlay(on: pin)        
        selectedLine = nil
        selectedText = nil
        
        drawColor = pin.color
    }
    
    func selectLine(_ line: Line) {
        selectedLine = line
        selectedPin = nil
        hidePinOverlay()
        
        drawColor = line.color
    }
    
    func selectText(_ text: Text) {
        selectedLine = nil
        selectedPin = nil
        selectedText = text
        hidePinOverlay()
        
        drawColor = text.color
    }
}

extension Canvas {
    /// Detect which element was tapped, and then toggle its selection
    func toggleSelection(_ tapLocation:CGPoint) {
        var hitDetected = false
        
        if didSelectPin(tapLocation) {
            hitDetected = true
        }
        
        if !hitDetected, didSelectLine(tapLocation) {
            hitDetected = true
        }
        
        if !hitDetected, didSelectText(tapLocation) {
            hitDetected = true
        }
        
        if !hitDetected {
            // if no elements tapped, deselect currently selected elements
            deselectAll()
        }
    }
    
    func didSelectPin(_ tapLocation:CGPoint) -> Bool {
        for pin in pins {
            if CGHelper.distance(tapLocation, pin.location) < Canvas.kPinTapThreshold {
                if pin == selectedPin {
                    // pin already selected, deselect it
                    deselectAll()
                } else {
                    selectPin(pin)
                    
                    // pin was selected
                    return true
                }
            }
        }
        return false
    }
    
    func didSelectText(_ tapLocation:CGPoint) -> Bool {
        for text in texts {
            // dummy label for hit test
            let label = UILabel()
            label.text = text.text
            label.textAlignment = .center
            label.sizeToFit()
            label.center = text.location
            
            if label.frame.contains(tapLocation) {
                if text == selectedText {
                    // text already selected, deselect it
                    deselectAll()
                } else {
                    selectText(text)
                    
                    // pin was selected
                    return true
                }
            }
        }
        return false
    }
    
    func didSelectLine(_ tapLocation:CGPoint) -> Bool {
        for line in lines {
            // verify path exists, and line has more than 1 point
            guard let path = line.path,
                line.points.count > 1 else {
                for point in line.points {
                    let distance = CGHelper.distance(tapLocation, point.location)
                    guard distance < Canvas.kLinePointTapThreshold else { continue }
                    
                    if line == selectedLine {
                        // line already selected, deselect it
                        deselectAll()
                    } else {
                        selectLine(line)
                        
                        // line was selected
                        return true
                    }
                }
                continue
            }
            
            // we need to copy the path, to hit test inside the entire drawn stroke
            let pathCgCopy = path.cgPath.copy(strokingWithWidth: Canvas.kLineTapThreshold, lineCap: path.lineCapStyle, lineJoin: path.lineJoinStyle, miterLimit: path.miterLimit)
            let lineHitPath = UIBezierPath(cgPath: pathCgCopy)
            if lineHitPath.contains(tapLocation) {
                if line == selectedLine {
                    // line already selected, deselect it
                    deselectAll()
                } else {
                    selectLine(line)
                    
                    // line was selected
                    return true
                }
            }
        }
        return false
    }
}
