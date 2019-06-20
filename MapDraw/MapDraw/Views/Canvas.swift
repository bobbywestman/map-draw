//
//  Canvas.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

struct PointGroup {
    var points: [CGPoint]
    var color: UIColor
    var path: UIBezierPath?
}

class Canvas: UIView {
    var groups = [PointGroup]()
    var currentGroup: PointGroup?
    
    @objc public func tapDetected(tapRecognizer:UITapGestureRecognizer) {
        let tapLocation:CGPoint = tapRecognizer.location(in: self)
        hitTest(tapLocation: CGPoint(x: tapLocation.x, y: tapLocation.y))
    }
    
    private func hitTest(tapLocation:CGPoint) {
        for group in groups {
            guard let path = group.path else {
                continue
            }
            
            // we need to copy the path, to hit test inside the entire drawn stroke
            let cgCopy = path.cgPath.copy(strokingWithWidth: path.lineWidth, lineCap: path.lineCapStyle, lineJoin: path.lineJoinStyle, miterLimit: path.miterLimit)
            let bezierCopy = UIBezierPath(cgPath: cgCopy)
            if bezierCopy.contains(tapLocation) {
                currentGroup = group
                print(path)
            }
        }
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
            
            let stroke = group.color
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
