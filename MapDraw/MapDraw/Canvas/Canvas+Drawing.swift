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
        texts = []
        deselectAll()
        draggingPin = nil
        draggingPoint = nil
        undoStore = []
        redoStore = []
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
    
    func updateTextLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        labels = []

        for text in texts {
            drawTextLabel(text)
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
                if line.color == .white {
                    stroke = line.color.darker()
                } else if line.color == .black {
                    stroke = line.color.lighter()
                } else {
                    stroke = line.color
                }

                let pattern: [CGFloat] = [3.0, 10.0]
                path.setLineDash(pattern, count: 2, phase: 0.0)
            } else {
                if line.color == .white {
                    stroke = line.color
                } else if line.color == .black {
                    stroke = line.color
                } else {
                    stroke = line.color.lighter()
                }
            }
            stroke.setStroke()
            path.stroke()
            
            if pathClosed(withPointsIn: line) {
                path.close()
                
                let fill = stroke.withAlphaComponent(0.13)
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
                
                // need to update selected group points for undo / redo
                selectLine(lines[i])
                return point
            }
        }
        
        return nil
    }
}

extension Canvas {
    func drawText(location: CGPoint, text: String) -> Text {
        let text = Text(id: UUID(), location: location, text: text, color: drawColor)
        texts.append(text)
        
        drawTextLabel(text)
        
        selectText(text)
        return text
    }
    
    func drawTextLabel(_ text: Text) {
        let label = UILabel()
        label.text = text.text
        label.textAlignment = .center
        label.sizeToFit()
        
        if let selected = selectedText, text == selected {
            if text.color == .white {
                label.textColor = text.color.darker()
            } else if text.color == .black {
                label.textColor = text.color.lighter()
            } else {
                label.textColor = text.color
            }
        } else {
            if text.color == .white {
                label.textColor = text.color
            } else if text.color == .black {
                label.textColor = text.color
            } else {
                label.textColor = text.color.lighter()
            }
        }
        
        addSubview(label)
        label.center = text.location
        
        labels.append(label)
    }
}

extension Canvas {
    func drawPin(_ tapLocation:CGPoint) -> Pin {
        let pin = Pin(id: UUID(), color: drawColor, location: tapLocation, label: pinLabel)
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
            if pin.color == .white {
                imageView.tintColor = pin.color.darker()
            } else if pin.color == .black {
                imageView.tintColor = pin.color.lighter()
            } else {
                imageView.tintColor = pin.color
            }
        } else {
            if pin.color == .white {
                imageView.tintColor = pin.color
            } else if pin.color == .black {
                imageView.tintColor = pin.color
            } else {
                imageView.tintColor = pin.color.lighter()
            }
        }
        
        let label = UILabel()
        label.text = pin.label
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        var red = CGFloat(0.0), green = CGFloat(0.0), blue = CGFloat(0.0), alpha = CGFloat(0.0)
        pin.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // TODO: move to color helper
        //https://stackoverflow.com/a/20978280/11687264
        let threshold = CGFloat(0.29)
        let delta = (red * 0.2999) + (green * 0.587) + (blue * 0.114)
        print(delta)
        label.textColor = (delta < threshold) ? .white : .black

        imageView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 3),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6),
            label.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.6),
        ])
        
        addSubview(imageView)
        pinImages.append(imageView)
    }
    
    func calculatePinImageCenter(_ pin: Pin) -> CGPoint {
        let height = Canvas.kPinHeight
        return CGPoint(x: pin.location.x, y: pin.location.y - (height / 2))
    }
}
