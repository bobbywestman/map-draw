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
    
    @objc func handleDrag(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        if recognizer.state == .began {
            dragStartedLocation = location
            
            guard let dragStartedLocation = dragStartedLocation else {
                return
            }
            
            hitTestForLinePoint(dragStartedLocation)
        }
        else if recognizer.state == .ended {
            dragStartedLocation = nil
            draggingPoint = nil
            return
        }
        
        guard draggingPoint != nil else {
            return
        }
        
        for i in 0..<groups.count {
            let group = groups[i]
            for j in 0..<group.points.count {
                let point = group.points[j]
                if point == draggingPoint {
                    groups[i].points[j].location = location
                }
            }
        }
    }
}

extension Canvas {
    private func tapDetected(tapLocation:CGPoint) {
        switch drawingState {
        case .line:
            drawLinePoint(tapLocation)
        case .none:
            hitTestForLinePath(tapLocation)
        default:
            break
        }
    }
    
    private func hitTestForLinePoint(_ tapLocation:CGPoint) {
        var closestPointInThreshold: Point?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for group in groups {
            
            guard group.points.count > 1 else {
                continue
            }
            
            for point in group.points {
                let delta = CGHelper.distance(tapLocation, point.location)
                guard delta < Canvas.kPointTapThreshold else {
                    continue
                }
                if delta < closestDistance {
                    closestDistance = delta
                    closestPointInThreshold = point
                }
            }
        }
        
        draggingPoint = closestPointInThreshold
    }
    
    private func hitTestForLinePath(_ tapLocation:CGPoint) {
        var hitDetected = false
        
        for group in groups {
            // verify path exists, some groups have 0 or 1 points
            guard let path = group.path else {
                continue
            }
            
            // we need to copy the path, to hit test inside the entire drawn stroke
            let cgCopy = path.cgPath.copy(strokingWithWidth: path.lineWidth, lineCap: path.lineCapStyle, lineJoin: path.lineJoinStyle, miterLimit: path.miterLimit)
            let bezierCopy = UIBezierPath(cgPath: cgCopy)
            if bezierCopy.contains(tapLocation) {
                // tap detected inside path
                hitDetected = true

                if group == selectedGroup {
                    // deselect group
                    selectedGroup = nil
                } else {
                    // select group
                    selectedGroup = group
                    drawColor = group.color
                    
                    // only select one line at a time in case of overlaps, break on first hit
                    break
                }
            }
        }
        
        if !hitDetected {
            // if no paths tapped, deselect currently selected group
            selectedGroup = nil
        }
    }
}
