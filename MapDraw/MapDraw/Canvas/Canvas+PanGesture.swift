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
            // line drawing mode enabled, hit test for dragging elements, and draw point if no hits detected
            // priority:
            //  1) drag line point
            //  2) drag pin
            //  3) draw line point
            
            // check if user is going to move a line point
            draggingPoint = hitTestForPanningLinePoint(location)
            
            guard  draggingPoint == nil else { break }
            
            // draw new point
            let x = location.x - Canvas.kDragHorizontalOffset
            let y = location.y - Canvas.kDragVerticalOffset
            draggingPoint = drawLinePoint(CGPoint(x: x , y: y))
        case .pin:
            // pin drawing mode enabled, hit test for dragging elements, and draw pin if no hits detected
            // priority:
            //  1) drag pin
            //  2) drag line point
            //  3) draw pin
            
            // check if user is going to move a pin
            draggingPin = hitTestForPanningPin(location)
            
            guard draggingPin == nil else { break }
            
            // draw new pin
            // draw new point
            let x = location.x - Canvas.kDragHorizontalOffset
            let y = location.y - Canvas.kDragVerticalOffset
            draggingPin = drawPin(CGPoint(x: x , y: y))
        case .none:
            // no drawing mode enabled, we can only drag elements
            // priority:
            //  1) drag pin
            //  2) drag line point
            
            // check if user is going to move a pin
            draggingPin = hitTestForPanningPin(location)
            
            guard draggingPin == nil else { break }
            
            // check if user is going to move a line point
            draggingPoint = hitTestForPanningLinePoint(location)
            
            guard draggingPoint == nil else { break }
            
            draggingText = hitTestForPanningText(location)
        default:
            break
        }
    }
    
    func panning(_ location:CGPoint) {
        var x = location.x - Canvas.kDragHorizontalOffset
        var y = location.y - Canvas.kDragVerticalOffset
        
        if draggingPoint != nil  {
            // adjust offset, to keep point within bounds
            // use +/- 1 so that bounds.contains() returns true
            if x < bounds.minX {
                x = bounds.minX + 1
            } else if x > bounds.maxX {
                x = bounds.maxX - 1
            }
            
            // adjust offset, to keep point within bounds
            // use +/- 1 so that bounds.contains() returns true
            if y < bounds.minY {
                y = bounds.minY + 1
            } else if y > bounds.maxY {
                y = bounds.maxY - 1
            }
            
            let offsetLocation = CGPoint(x: x, y: y)
            guard bounds.contains(offsetLocation) else { return }
            
            // find the point that's being moved, and update location
            for i in 0..<lines.count {
                let line = lines[i]
                for j in 0..<line.points.count {
                    let point = line.points[j]
                    if point == draggingPoint {
                        lines[i].points[j].location = offsetLocation
                        draggingPoint = lines[i].points[j]
                        selectLine(lines[i])
                    }
                }
            }
        } else if draggingPin != nil {
            // adjust offset, to keep pin image within bounds
            // use +/- 1 so that bounds.contains() returns true
            if x < bounds.minX + (Canvas.kPinWidth / 2) {
                x = bounds.minX + (Canvas.kPinWidth / 2) + 1
            } else if x > bounds.maxX - (Canvas.kPinWidth / 2) {
                x = bounds.maxX - (Canvas.kPinWidth / 2) - 1
            }
            
            // adjust offset, to keep pin image within bounds
            // use +/- 1 so that bounds.contains() returns true
            if y < bounds.minY + (Canvas.kPinHeight) {
                y = bounds.minY + (Canvas.kPinHeight) + 1
            } else if y > bounds.maxY {
                y = bounds.maxY - 1
            }
            
            let offsetLocation = CGPoint(x: x, y: y)
            guard bounds.contains(offsetLocation) else { return }
            
            // find the pin that's being moved, and update location
            for i in 0..<pins.count {
                let pin = pins[i]
                if pin == draggingPin {
                    pins[i].location = offsetLocation
                    draggingPin = pins[i]
                    selectPin(pins[i])
                }
            }
        } else if draggingText != nil {
            let offsetLocation = CGPoint(x: x, y: y)
            guard bounds.contains(offsetLocation) else { return }
            
            // find the pin that's being moved, and update location
            for i in 0..<texts.count {
                let text = texts[i]
                if text == draggingText {
                    texts[i].location = offsetLocation
                    draggingText = texts[i]
                    selectText(texts[i])
                }
            }
        }
    }
    
    func panEnded(_ location:CGPoint) {
        switch drawingState {
        case .line:
            guard draggingPoint != nil else { break }
            
            // connect / close line if let go close enough to the first point
            for i in 0..<lines.count {
                let line = lines[i]
                guard line == selectedLine,
                    line.points.count > 3,
                    let firstPoint = line.points.first,
                    let lastPoint = line.points.last,
                    draggingPoint == lastPoint || draggingPoint == firstPoint,
                    CGHelper.distance(lastPoint.location, firstPoint.location) < Canvas.kLinePointConnectThreshold else {
                    continue
                }
                
                if draggingPoint == firstPoint {
                    // first point was dragged close enough to last point to connect & complete the path
                    // replace first point with the last one
                    lines[i].points[0] = lastPoint
                    draggingPoint = lastPoint
                    selectLine(lines[i])
                } else if draggingPoint == lastPoint {
                    // last point was dragged close enough to first point to connect & complete the path
                    // replace last point with the frist one
                    lines[i].points[line.points.count - 1] = firstPoint
                    draggingPoint = firstPoint
                    selectLine(lines[i])
                }
            }
            
            undoableInteractionOccured()
        case .pin:
            guard draggingPin != nil else { break }
            
            undoableInteractionOccured()
        default:
            if draggingPoint != nil {
                undoableInteractionOccured()
            } else if draggingPin != nil {
                undoableInteractionOccured()
            } else if draggingText != nil {
                undoableInteractionOccured()
            }
            
            break
        }
        
        // pan ended, reset dragging points
        draggingPoint = nil
        draggingPin = nil
        draggingText = nil
    }
}

extension Canvas {
    private func hitTestForPanningLinePoint(_ location:CGPoint) -> LinePoint? {
        var closestPointInThreshold: LinePoint?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for line in lines {
            guard line.points.count > 0 else { continue }
            
            if drawingState == .line {
                guard line == selectedLine else { continue }
            }
            
            for point in line.points {
                let distance = CGHelper.distance(location, point.location)
                guard distance < Canvas.kLinePointTapThreshold else { continue }
                
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
    private func hitTestForPanningText(_ location: CGPoint) -> Text? {
        var closestTextInThreshold: Text?
        var closestDistance = CGHelper.maxDistance() // use maximum possible distance as initial closest distance until a calculation has actually been made
        
        for text in texts {
            // dummy label for hit test
            let label = UILabel()
            label.text = text.text
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
            label.sizeToFit()
            label.center = text.location
            guard label.frame.contains(location) else { continue }
            
            let distance = CGHelper.distance(location, text.location)
            if distance < closestDistance {
                closestDistance = distance
                closestTextInThreshold = text
            }
        }
        
        return closestTextInThreshold
    }
}

extension Canvas {
    private func hitTestForPanningPin(_ location:CGPoint) -> Pin? {
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
