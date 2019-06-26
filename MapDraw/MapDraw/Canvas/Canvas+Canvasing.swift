//
//  Canvas+Canvasing.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/23/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension Canvas: Canvasing {
    func setColor(_ color: UIColor) {
        drawColor = color
        
        if let selectedLine = selectedLine,
            let index = lines.index(of: selectedLine) {
            lines[index].color = color
        } else if let selectedPin = selectedPin,
            let index = pins.index(of: selectedPin) {
            pins[index].color = color
        }
    }
    
    func drawingLine() {
        selectedPin = nil
        
        switch drawingState {
        case .line:
            drawingState = .none
            selectedLine = nil
        default:
            drawingState = .line
        }
    }
    
    func drawingPin() {
        selectedLine = nil
        
        switch drawingState {
        case .pin:
            drawingState = .none
            selectedPin = nil
        default:
            drawingState = .pin
        }
    }
    
    func drawingBox() {
        selectedLine = nil
        selectedPin = nil
        
        switch drawingState {
        case .box:
            drawingState = .none
        default:
            drawingState = .box
        }
    }
    
    func undo() {
        guard let selectedLine = selectedLine, selectedLine.points.count > 0 else {
            return
        }
        
        if let index = lines.index(of: selectedLine),
            let lastPoint = lines[index].points.last {
            lines[index].redoPoints.append(lastPoint)
            lines[index].points.removeLast()
            
            // update selectedLine
            self.selectedLine = lines[index]
        }
    }
    
    func redo() {
        guard let selectedLine = selectedLine else {
            return
        }
        
        if let index = lines.index(of: selectedLine),
            let lastPoint = lines[index].redoPoints.last {
            lines[index].points.append(lastPoint)
            
            lines[index].redoPoints.removeLast()
            
            // update selectedLine
            self.selectedLine = lines[index]
        }
    }
    
    func clear() {
        clearDrawings()
    }
    
    func deselect() {
        deselectAll()
    }
}
