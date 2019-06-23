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
    func clearDrawings() {
        lines = []
        pins = []
    }
}

extension Canvas {
    func updatePinImages() {
        for image in pinImages {
            image.removeFromSuperview()
        }
        pinImages = []
        
        for pin in pins {
            drawPinImage(pin)
        }
    }
    
    override func draw(_ rect: CGRect) {
        for i in 0..<lines.count {
            let line = lines[i]
            
            guard line.points.count > 0 else {
                continue
            }
            
            let path = UIBezierPath()
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            path.lineWidth = 5
            
            path.move(to: line.points[0].location)
            for point in line.points.dropFirst() {
                path.addLine(to: point.location)
            }
            
            let stroke: UIColor
            if let selected = selectedLine, line == selected {
                stroke = line.color.lighter()
            } else {
                stroke = line.color
            }
            stroke.setStroke()
            path.stroke()
            
            if pathClosed(withPointsIn: line) {
                path.close()
                
                let fill = stroke.withAlphaComponent(0.25)
                fill.setFill()
                path.fill()
            }
            
            lines[i].path = path
        }
    }
}

extension Canvas {
    func pathClosed(withPointsIn line: Line) -> Bool {
        if line.points.count > 2, line.points.first == line.points.last {
            return true
        }
        return false
    }
}

extension Canvas {
    /// Used to add a point to a line
    func drawLinePoint(_ tapLocation:CGPoint) {
        guard let selectedLine = selectedLine else {
            // create a new line if no line is currently selected
            let point = LinePoint(id: UUID(), location: tapLocation)
            let points = [point]
            let color = drawColor
            let id = UUID()
            let newLine = Line(id: id, points: points, color: color)
            lines.append(newLine)
            
            // new group created, select it
            self.selectedLine = newLine
            return
        }
        
        guard !pathClosed(withPointsIn: selectedLine) else {
            // draw line points only on lines that do not have closed/compelted paths
            return
        }
        
        // append point to selected group
        for i in 0..<lines.count {
            let line = lines[i]
            if line == selectedLine {
                if line.points.count > 2,
                    let firstPoint = line.points.first,
                    CGHelper.distance(tapLocation, firstPoint.location) < Canvas.kLinePointConnectThreshold {
                    // point was drawn close enough to first point to connect & complete the path
                    lines[i].points.append(firstPoint)
                    
                    // path complete, reset drawing state + deselect, since no more line points can be added for this group
                    self.selectedLine = nil
                    drawingState = .none
                } else {
                    // new point was drawn
                    let point = LinePoint(id: UUID(), location: tapLocation)
                    lines[i].points.append(point)
                }
                
                // a new point has been made, reset any saved redo points
                lines[i].redoPoints = []
                
                // need to update selected group points for undo / redo
                self.selectedLine = lines[i]
                return
            }
        }
    }
}

extension Canvas {
    func drawPin(_ tapLocation:CGPoint) {
        let pin = Pin(id: UUID(), color: drawColor, location: tapLocation)
        pins.append(pin)
        
        drawPinImage(pin)
    }
    
    func drawPinImage(_ pin: Pin) {
        let image = UIImage(named: "Pin")?.withRenderingMode(.alwaysTemplate)
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = pin.color
        
        let width = CGFloat(16.75)
        let height = CGFloat(24)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView.center = CGPoint(x: pin.location.x, y: pin.location.y - height)
        
        addSubview(imageView)
        pinImages.append(imageView)
    }
}
