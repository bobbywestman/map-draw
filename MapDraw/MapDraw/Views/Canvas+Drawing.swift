//
//  Canvas+Drawing.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/21/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension Canvas {
    override func draw(_ rect: CGRect) {
        for i in 0..<groups.count {
            let group = groups[i]
            
            guard group.points.count > 0 else {
                continue
            }
            
            let path = UIBezierPath()
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            path.lineWidth = 5
            
            path.move(to: group.points[0].location)
            for point in group.points.dropFirst() {
                path.addLine(to: point.location)
            }
            
            let stroke: UIColor
            if let selected = selectedGroup, group == selected {
                stroke = group.color.lighter()
            } else {
                stroke = group.color
            }
            stroke.setStroke()
            path.stroke()
            
            if pathClosed(withPointIn: group) {
                path.close()
                
                let fill = stroke.withAlphaComponent(0.25)
                fill.setFill()
                path.fill()
            }
            
            groups[i].path = path
        }
    }
}

extension Canvas {
    func pathClosed(withPointIn group: PointGroup) -> Bool {
        if group.points.count > 2, group.points.first == group.points.last {
            return true
        }
        return false
    }
}

extension Canvas {
    func drawLinePoint(_ tapLocation:CGPoint) {
        guard let selected = selectedGroup else {
            // create a new group if no group is currently selected
            let point = Point(id: UUID(), location: tapLocation)
            let points = [point]
            let color = drawColor
            let id = UUID()
            let newGroup = PointGroup(id: id, points: points, color: color)
            groups.append(newGroup)
            
            // new group created, select it
            selectedGroup = newGroup
            return
        }
        
        guard !pathClosed(withPointIn: selected) else {
            // draw line points only on groups that do not have closed/compelted paths
            return
        }
        
        // append point to selected group
        for i in 0..<groups.count {
            let group = groups[i]
            if group == selected {
                if let firstPoint = group.points.first,
                    distance(tapLocation, firstPoint.location) < kPointConnectThreshold {
                    // point was drawn close enough to first point to connect & complete the path
                    groups[i].points.append(firstPoint)
                    
                    // path complete, reset drawing state, since no more line points can be added for this group
                    drawingState = .none
                } else {
                    // new point was drawn
                    let point = Point(id: UUID(), location: tapLocation)
                    groups[i].points.append(point)
                }
                
                // a new point has been made, reset any saved redo points
                groups[i].redoPoints = []
                
                // need to update selected group points for undo / redo
                selectedGroup = groups[i]
                return
            }
        }
    }
}
