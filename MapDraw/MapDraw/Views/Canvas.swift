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
    weak var delegate: CanvasHandling?
    
    var groups = [PointGroup]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var selectedGroup: PointGroup? {
        didSet {
            setNeedsDisplay()
        }
    }

    var drawingState: DrawingState = .none {
        didSet {
            print(drawingState)
            
            delegate?.drawingChanged(to: drawingState)
        }
    }
    
    var drawColor: UIColor = .black {
        didSet {
            delegate?.colorChanged(to: drawColor)
        }
    }
    
    @objc public func tapDetected(tapRecognizer:UITapGestureRecognizer) {
        hitTest(tapLocation: tapRecognizer.location(in: self))
    }

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
    private func hitTest(tapLocation:CGPoint) {
        switch drawingState {
        case .line:
            drawLinePoint(tapLocation)
        case .none:
            toggleSelectedGroup(tapLocation)
        default:
            break
        }
    }
    
    private func toggleSelectedGroup(_ tapLocation:CGPoint) {
        guard drawingState == .none else {
            return
        }
        
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
                    break // only select one line at a time, break on first hit
                }
            }
        }
    }
}

extension Canvas {
    func drawLinePoint(_ tapLocation:CGPoint) {
        // append point to selected group
        for i in 0..<groups.count {
            let group = groups[i]
            if let selected = selectedGroup, group == selected {
                groups[i].points.append(tapLocation)
                groups[i].redoPoints = []
                selectedGroup = groups[i] // need to update selected group points for undo / redo
                return
            }
        }
        
        // or create a new group if the selected group doesnt exit
        let points = [tapLocation]
        let color = drawColor
        let id = UUID()
        let newGroup = PointGroup(id: id, points: points, color: color)
        selectedGroup = newGroup
        groups.append(newGroup)
    }
}
