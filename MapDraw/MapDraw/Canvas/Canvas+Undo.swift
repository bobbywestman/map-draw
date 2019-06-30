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
        let state = CanvasState(pins: pins, lines: lines)
        undoStore.append(state)
        redoStore = []
    }
    
    func undoLastInteraction() {
        guard let lastInteraction = undoStore.last else { return }
        
        undoStore.removeLast()
        redoStore.append(lastInteraction)
        
        restoreInteraction()
    }
    
    func redoLastUndoneInteraction() {
        guard let lastUndo = redoStore.last else { return }
        
        redoStore.removeLast()
        undoStore.append(lastUndo)
        
        restoreInteraction()
    }
    
    private func restoreInteraction() {
        guard let restoredInteraction = undoStore.last else {
            lines = []
            pins = []
            setNeedsDisplay()
            return
        }
        
        lines = restoredInteraction.lines
        pins = restoredInteraction.pins
        setNeedsDisplay()
    }
}
