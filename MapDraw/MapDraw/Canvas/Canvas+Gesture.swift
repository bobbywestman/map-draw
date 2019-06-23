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
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            hitTestForLinePoint(location)
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
                
            }
        }
    }
}

extension Canvas {
    private func tapDetected(tapLocation:CGPoint) {
        switch drawingState {
        case .line:
            drawLinePoint(tapLocation)
        case .pin:
            drawPin(tapLocation)
        case .none:
            hitTestForLinePath(tapLocation)
        default:
            break
        }
    }
}

extension Canvas {
    /// Used to add a point to a line
    private func hitTestForLinePoint(_ tapLocation:CGPoint) {
        var closestPointInThreshold: LinePoint?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for line in lines {
            guard line.points.count > 1 else {
                continue
            }
            
            for point in line.points {
                let distance = CGHelper.distance(tapLocation, point.location)
                guard distance < Canvas.kPointTapThreshold else {
                    continue
                }
                if distance < closestDistance {
                    closestDistance = distance
                    closestPointInThreshold = point
                }
            }
        }
        
        draggingPoint = closestPointInThreshold
    }
    
    /// Used to handle selection of a path
    private func hitTestForLinePath(_ tapLocation:CGPoint) {
        var hitDetected = false
        
        for line in lines {
            // verify path exists, some lines have 0 or 1 points
            guard let path = line.path else {
                continue
            }
            
            // we need to copy the path, to hit test inside the entire drawn stroke
            let cgCopy = path.cgPath.copy(strokingWithWidth: path.lineWidth, lineCap: path.lineCapStyle, lineJoin: path.lineJoinStyle, miterLimit: path.miterLimit)
            let bezierCopy = UIBezierPath(cgPath: cgCopy)
            if bezierCopy.contains(tapLocation) {
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
        
        if !hitDetected {
            // if no paths tapped, deselect currently selected line
            selectedLine = nil
        }
    }
}
