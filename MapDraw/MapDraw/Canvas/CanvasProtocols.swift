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
    func drawLine()
    func drawPin()
    func drawBox()
    func undo()
    func redo()
    func clear()
    func deselect()
}

/// Protocol for handling events from a Canvas.
protocol CanvasHandling: class {
    
    /// Drawing state has changed.
    func drawingChanged(to state: DrawingState)
    
    /// Drawing color has changed.
    func colorChanged(to color: UIColor)
}
