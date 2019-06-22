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
            
            if group.points.count > 2, group.points.first == group.points.last {
                path.close()
                
                let fill = stroke.withAlphaComponent(0.25)
                fill.setFill()
                path.fill()
                
                // path complete, deselect
                selectedGroup = nil
                drawingState = .none
            }
            
            groups[i].path = path
        }
    }
}

extension Canvas {
    func drawLinePoint(_ tapLocation:CGPoint) {
        // append point to selected group
        for i in 0..<groups.count {
            let group = groups[i]
            if let selected = selectedGroup, group == selected {
                let point = Point(id: UUID(), location: tapLocation)
                groups[i].points.append(point)
                groups[i].redoPoints = []
                
                // need to update selected group points for undo / redo
                selectedGroup = groups[i]
                return
            }
        }
        
        // or create a new group if the selected group doesnt exit
        let point = Point(id: UUID(), location: tapLocation)
        let points = [point]
        let color = drawColor
        let id = UUID()
        let newGroup = PointGroup(id: id, points: points, color: color)
        selectedGroup = newGroup
        groups.append(newGroup)
    }
}
