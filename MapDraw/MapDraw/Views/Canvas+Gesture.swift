//
//  Canvas+Gesture.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/21/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

let kPointTapThreshold = CGFloat(20)

// TODO: move this
func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return CGFloat(sqrt(xDist * xDist + yDist * yDist))
}

extension Canvas {
    @objc public func tapDetected(tapRecognizer:UITapGestureRecognizer) {
        hitTest(tapLocation: tapRecognizer.location(in: self))
    }
    
    @objc public func dragDetected(dragRecognizer:UIPanGestureRecognizer) {
        let location = dragRecognizer.location(in: self)
        
        if dragRecognizer.state == .began {
            dragStartedLocation = location
            
            guard let dragStartedLocation = dragStartedLocation else {
                return
            }
            
            hitTestForLinePoint(dragStartedLocation)
        }
        else if dragRecognizer.state == .ended {
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
    private func hitTest(tapLocation:CGPoint) {
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
        var closestDistance = CGFloat.greatestFiniteMagnitude
        
        for group in groups {
            
            guard group.points.count > 1 else {
                continue
            }
            
            for point in group.points {
                let delta = distance(tapLocation, point.location)
                guard delta < kPointTapThreshold else {
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
        for group in groups {
            // Should be able to select completed paths, since the undo / redo button can still work
            //            // don't select completed paths
            //            guard group.points.first != group.points.last else {
            //                continue
            //            }
            
            //check toggle selection if path exists
            guard let path = group.path else {
                continue
            }
            
            // we need to copy the path, to hit test inside the entire drawn stroke
            let cgCopy = path.cgPath.copy(strokingWithWidth: path.lineWidth, lineCap: path.lineCapStyle, lineJoin: path.lineJoinStyle, miterLimit: path.miterLimit)
            let bezierCopy = UIBezierPath(cgPath: cgCopy)
            if bezierCopy.contains(tapLocation) {
                // tap detected inside path
                
                if group == selectedGroup {
                    selectedGroup = nil
                } else {
                    selectedGroup = group
                    drawColor = group.color
                    
                    // only select one line at a time in case of overlaps, break on first hit
                    break
                }
            }
        }
    }
}
