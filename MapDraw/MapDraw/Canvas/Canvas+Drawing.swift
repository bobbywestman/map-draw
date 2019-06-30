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
        deselectAll()
        draggingPin = nil
        draggingPoint = nil
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
            guard line.points.count > 0 else { continue }
            
            let path = UIBezierPath()
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
            path.lineWidth = Canvas.kLineWidth
            
            for j in 0..<line.points.count {
                let point = line.points[j]
  
                // handle path
                guard j > 0 else {
                    path.move(to: line.points[0].location)
                    continue
                }
                path.addLine(to: point.location)
            }
            
            let stroke: UIColor
            if line == selectedLine {
                stroke = line.color
                let pattern: [CGFloat] = [3.0, 10.0]
                path.setLineDash(pattern, count: 2, phase: 0.0)
            } else {
                stroke = line.color.lighter()
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
            
            // draw points after drawing lines, so they're on top
            for j in 0..<line.points.count {
                let point = line.points[j]
                
                let diameter: CGFloat
                if line == selectedLine {
                    diameter = Canvas.kLinePointDiameter
                } else {
                    diameter = 0
                }
                let radius = diameter / 2
                
                // draw point
                let dotPath = UIBezierPath(ovalIn: CGRect(x: point.location.x - radius, y: point.location.y - radius, width: diameter, height: diameter))
                dotPath.close()
                let dotFill: UIColor
                if line == selectedLine {
                    dotFill = line.color.lighter().lighter()
                } else {
                    dotFill = line.color.lighter()
                }
                dotFill.setFill()
                dotPath.fill()
            }
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
    func drawLinePoint(_ tapLocation:CGPoint) -> LinePoint? {
        guard let selectedLine = selectedLine, !pathClosed(withPointsIn: selectedLine) else {
            // create a new line if no line is currently selected, or the selected line is closed
            // draw line points only on lines that do not have closed/compelted paths

            let point = LinePoint(id: UUID(), location: tapLocation)
            let color = drawColor
            let id = UUID()
            let newLine = Line(id: id, points: [point], color: color)
            lines.append(newLine)
            
            // new group created, select it
            selectLine(newLine)
            return point
        }
        
        // append point to selected group
        for i in 0..<lines.count {
            let line = lines[i]
            if line == selectedLine {
                let point: LinePoint
                
                if line.points.count > 2,
                    let firstPoint = line.points.first,
                    CGHelper.distance(tapLocation, firstPoint.location) < Canvas.kLinePointConnectThreshold {
                    // point was drawn close enough to first point to connect & complete the path
                    point = firstPoint
                    lines[i].points.append(point)
                } else {
                    // new point was drawn
                    point = LinePoint(id: UUID(), location: tapLocation)
                    lines[i].points.append(point)
                }
                
                // a new point has been made, reset any saved redo points
                lines[i].redoPoints = []
                
                // need to update selected group points for undo / redo
                selectLine(lines[i])
                return point
            }
        }
        
        return nil
    }
}

extension Canvas {
    func drawPin(_ tapLocation:CGPoint) -> Pin {
        let pin = Pin(id: UUID(), color: drawColor, location: tapLocation, value: pinNumber)
        pins.append(pin)
        
        drawPinImage(pin)
        
        selectPin(pin)
        return pin
    }
    
    func drawPinImage(_ pin: Pin) {
        let image = UIImage(named: "Pin")
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: 0, y: 0, width: Canvas.kPinWidth, height: Canvas.kPinHeight)
        imageView.center = calculatePinImageCenter(pin)
        
        if let selected = selectedPin, pin == selected {
             imageView.tintColor = pin.color
        } else {
             imageView.tintColor = pin.color.lighter()
        }
        
        addSubview(imageView)
        pinImages.append(imageView)
    }
    
    func calculatePinImageCenter(_ pin: Pin) -> CGPoint {
        let height = Canvas.kPinHeight
        return CGPoint(x: pin.location.x, y: pin.location.y - (height / 2))
    }
}
