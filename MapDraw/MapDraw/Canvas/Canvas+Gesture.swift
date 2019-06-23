//
//  Canvas+Gesture.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/21/19.
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
            drawLinePoint(tapLocation)
        case .pin:
            drawPin(tapLocation)
        case .none:
            toggleSelection(tapLocation)
        default:
            break
        }
    }
}

extension Canvas {
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            switch drawingState {
            case .line:
                draggingPoint = hitTestForPanningLinePoint(location)
            case .pin:
                draggingPin = hitTestForPanningPin(location)
            case .none:
                draggingPin = hitTestForPanningPin(location)
                
                if draggingPin == nil {
                    draggingPoint = hitTestForPanningLinePoint(location)
                }
            default:
                break
            }
        case .ended:
            draggingPoint = nil
            draggingPin = nil
            return
        default:
            if draggingPoint != nil  {
                for i in 0..<lines.count {
                    let line = lines[i]
                    for j in 0..<line.points.count {
                        let point = line.points[j]
                        if point == draggingPoint {
                            lines[i].points[j].location = location
                        }
                    }
                }
            } else if draggingPin != nil {
                for i in 0..<pins.count {
                    let pin = pins[i]
                    if pin == draggingPin {
                        pins[i].location = location
                    }
                }
            }
        }
    }
    
    private func hitTestForPanningLinePoint(_ tapLocation:CGPoint) -> LinePoint? {
        var closestPointInThreshold: LinePoint?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for line in lines {
            guard line.points.count > 1 else {
                continue
            }
            
            for point in line.points {
                let distance = CGHelper.distance(tapLocation, point.location)
                guard distance < Canvas.kLinePointTapThreshold else {
                    continue
                }
                if distance < closestDistance {
                    closestDistance = distance
                    closestPointInThreshold = point
                }
            }
        }
        
        return closestPointInThreshold
    }
    
    private func hitTestForPanningPin(_ tapLocation:CGPoint) -> Pin? {
        var closestPinInThreshold: Pin?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for pin in pins {
            let distance = CGHelper.distance(tapLocation, pin.location)
            guard distance < Canvas.kPinTapThreshold else {
                continue
            }
            if distance < closestDistance {
                closestDistance = distance
                closestPinInThreshold = pin
            }
        }
        
        return closestPinInThreshold
    }
}

extension Canvas {
    /// Used to handle selection of a path
    private func toggleSelection(_ tapLocation:CGPoint) {
        var hitDetected = false
        
        for pin in pins {
            if CGHelper.distance(tapLocation, pin.location) < Canvas.kPinTapThreshold {
                // tap detected for pin
                hitDetected = true
                
                if pin == selectedPin {
                    // deselect pin
                    selectedPin = nil
                } else {
                    // select pin
                    selectedPin = pin
                    drawColor = pin.color
                    
                    // only select one pin at a time in case of overlaps, break on first hit
                    break
                }
            }
        }
        
        if !hitDetected {
            for line in lines {
                // verify path exists, some lines have 0 or 1 points
                guard let path = line.path else {
                    continue
                }
                
                // we need to copy the path, to hit test inside the entire drawn stroke
                let pathCgCopy = path.cgPath.copy(strokingWithWidth: path.lineWidth, lineCap: path.lineCapStyle, lineJoin: path.lineJoinStyle, miterLimit: path.miterLimit)
                let lineHitPath = UIBezierPath(cgPath: pathCgCopy)
                if lineHitPath.contains(tapLocation) {
                    // tap detected inside path
                    hitDetected = true
                    
                    if line == selectedLine {
                        // deselect line
                        selectedLine = nil
                    } else {
                        // select line
                        selectedLine = line
                        drawColor = line.color
                        
                        // only select one line at a time in case of overlaps, break on first hit
                        break
                    }
                }
            }
        }
        
        if !hitDetected {
            // if no paths tapped, deselect currently selected elements
            deselect()
        }
    }
}
