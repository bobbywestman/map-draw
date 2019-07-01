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
    func setPinLabel(_ label: String) {
        pinLabel = label
        
        if let selectedPin = selectedPin,
            let index = pins.index(of: selectedPin) {
            pins[index].label = label
        }
    }
    
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
        undoLastInteraction()
    }
    
    func redo() {
        redoLastUndoneInteraction()
    }
    
    func deleteSelected() {
        if let selectedPin = selectedPin,
            let index = pins.index(of: selectedPin) {
            
            pins.remove(at: index)
            
            undoableInteractionOccured()
        }
        
        if let selectedLine = selectedLine,
            let index = lines.index(of: selectedLine){
            
            lines.remove(at: index)
            
            undoableInteractionOccured()
        }
    }
    
    func clear() {
        clearDrawings()
    }
    
    func deselect() {
        deselectAll()
    }
}
