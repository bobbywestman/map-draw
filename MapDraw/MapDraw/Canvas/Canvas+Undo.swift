//
//  Canvas+Undo.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/30/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation

extension Canvas {
    func undoableInteractionOccured() {
        let state = CanvasState(pins: pins, lines: lines, selectedLine: selectedLine, selectedPin: selectedPin, drawColor: drawColor, pinLabel: pinLabel)
        undoStore.append(state)
        redoStore = []
    }
    
    func undoLastInteraction() {
        guard let lastInteraction = undoStore.last else { return }
        
        // move current state to redoStore
        undoStore.removeLast()
        redoStore.append(lastInteraction)
        
        // restore previous state
        restoreCanvasState(undoStore.last)
    }
    
    func redoLastUndoneInteraction() {
        guard let lastUndo = redoStore.last else { return }
        
        // move last undone state to undoStore
        redoStore.removeLast()
        undoStore.append(lastUndo)
        
        // restore that last undone state
        restoreCanvasState(undoStore.last)
    }
    
    private func restoreCanvasState(_ state: CanvasState?) {
        guard let restoredState = state else {
            lines = []
            pins = []
            deselectAll()
            return
        }
        
        if let selectedLine = restoredState.selectedLine {
            selectLine(selectedLine)
        } else if let selectedPin = restoredState.selectedPin {
            selectPin(selectedPin)
        }
        
        drawColor = restoredState.drawColor
        pinLabel = restoredState.pinLabel
        lines = restoredState.lines
        pins = restoredState.pins
    }
}
