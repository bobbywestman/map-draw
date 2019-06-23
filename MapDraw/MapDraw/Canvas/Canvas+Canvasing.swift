//
//  Canvas+Canvasing.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/23/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation

extension Canvas: Canvasing {
    func drawLine() {
        switch drawingState {
        case .line:
            drawingState = .none
            selectedLine = nil
        default:
            drawingState = .line
        }
    }
    
    func drawPin() {
        selectedLine = nil
        
        switch drawingState {
        case .pin:
            drawingState = .none
        default:
            drawingState = .pin
        }
    }
    
    func drawBox() {
        selectedLine = nil
        
        switch drawingState {
        case .box:
            drawingState = .none
        default:
            drawingState = .box
        }
    }
    
    func undo() {
        guard let selectedLine = selectedLine, selectedLine.points.count > 1 else {
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
}
