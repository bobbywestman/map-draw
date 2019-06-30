//
//  CanvasProtocols.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

/// Protocol for sending events to a Canvas.
protocol Canvasing: class {
    func setColor(_ color: UIColor)
    func setPinValue(_ value: Int)
    func drawingLine()
    func drawingPin()
    func drawingBox()
    func undo()
    func redo()
    func deleteSelected()
    func clear()
    func deselect()
}

/// Protocol for handling events from a Canvas.
protocol CanvasHandling: class {
    /// Drawing state has changed.
    func drawingChanged(to state: DrawingState)
    
    /// Drawing color has changed.
    func colorChanged(to color: UIColor)
    
    /// Pin number has changed.
    func pinValueChanged(to value: Int)
    
    func undoEnabled()
    func undoDisabled()
    func redoEnabled()
    func redoDisabled()
    func deleteEnabled()
    func deleteDisabled()
}
