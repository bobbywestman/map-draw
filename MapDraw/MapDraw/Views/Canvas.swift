//
//  Canvas.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

class Canvas: UIView {
    var groups = [PointGroup]()
    var selectedGroup: PointGroup?
    
    @objc public func tapDetected(tapRecognizer:UITapGestureRecognizer) {
        hitTest(tapLocation: tapRecognizer.location(in: self))
    }

    override func draw(_ rect: CGRect) {
        for i in 0..<groups.count {
            let group = groups[i]
            
            let path = UIBezierPath()
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            path.lineWidth = 10
            
            path.move(to: group.points[0])
            for point in group.points.dropFirst() {
                path.addLine(to: point)
            }
            
            let stroke: UIColor
            if let selected = selectedGroup, group == selected {
                stroke = group.color.lighter()
            } else {
                stroke = group.color
            }
            stroke.setStroke()
            path.stroke()
            
            if group.points.first == group.points.last {
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
    private func hitTest(tapLocation:CGPoint) {
        toggleSelectedGroup(tapLocation)
    }
    
    private func toggleSelectedGroup(_ tapLocation:CGPoint) {
        for group in groups {
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
                    setNeedsDisplay()
                } else {
                    selectedGroup = group
                    setNeedsDisplay()
                    break // only select one line at a time, break on first hit
                }
            }
        }
    }
}
