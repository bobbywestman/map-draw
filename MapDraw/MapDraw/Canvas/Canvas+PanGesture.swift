//
//  Canvas+PanGesture.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/25/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension Canvas {
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            panBegan(location)
        case .ended:
            panEnded(location)
        default:
            panning(location)
        }
    }
    
    func panBegan(_ location:CGPoint) {
        switch drawingState {
        case .line:
            // check if user is going to move a line point
            draggingPoint = hitTestForPanningLinePoint(location)
            
            // if not, draw a point
            if draggingPoint == nil {
                draggingPoint = drawLinePoint(location)
            }
        case .pin:
            // check if user is going to move a pin
            draggingPin = hitTestForPanningPin(location)
            
            // if not, draw a pin
            if draggingPin == nil {
                draggingPin = drawPin(location)
            }
        case .none:
            // no drawing mode enabled, we can only drag elements
            
            // check if user is going to move a pin
            draggingPin = hitTestForPanningPin(location)
            
            // if not, check if user is going to move a line point
            if draggingPin == nil {
                draggingPoint = hitTestForPanningLinePoint(location)
            }
        default:
            break
        }
    }
    
    func panEnded(_ location:CGPoint) {
        switch drawingState {
        case .line:
            // connect line if close enough
            for i in 0..<lines.count {
                let line = lines[i]
                if line == selectedLine {
                    if line.points.count > 3,
                        let firstPoint = line.points.first,
                        CGHelper.distance(location, firstPoint.location) < Canvas.kLinePointConnectThreshold {
                        // point was dragged close enough to first point to connect & complete the path
                        // remove last point, and replace it with the frist one
                        lines[i].points.removeLast()
                        lines[i].points.append(firstPoint)
                        
                        // path complete, reset drawing state, since no more line points can be added for this group
                        drawingState = .none
                    }
                }
            }
        default:
            break
        }
        
        // pan ended, reset dragging points
        draggingPoint = nil
        draggingPin = nil
    }
    
    func panning(_ location:CGPoint) {
        
        if draggingPoint != nil  {
            // find the point that's being moved, and update location
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
            // find the pin that's being moved, and update location
            for i in 0..<pins.count {
                let pin = pins[i]
                if pin == draggingPin {
                    pins[i].location = location
                }
            }
        }
    }
}

extension Canvas {
    private func hitTestForPanningLinePoint(_ location:CGPoint) -> LinePoint? {
        var closestPointInThreshold: LinePoint?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for line in lines {
            guard line.points.count > 1 else {
                continue
            }
            
            for point in line.points {
                let distance = CGHelper.distance(location, point.location)
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
}

extension Canvas {
    private func hitTestForPanningPin(_ location:CGPoint) -> Pin? {
        var closestPinInThreshold: Pin?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for pin in pins {
            let distance = CGHelper.distance(location, pin.location)
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
