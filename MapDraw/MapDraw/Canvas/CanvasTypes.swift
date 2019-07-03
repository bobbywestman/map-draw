//
//  CanvasTypes.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation

/// A type that defines the current drawing state of the canvas.
enum DrawingState {
    /// User is drawing lines.
    case line
    
    /// User is inserting text.
    case text
    
    /// User is adding pins.
    case pin
    
    /// User is not drawing.
    /// Some other actions may be occurring, such as selecting lines to edit, moving line points, etc.
    case none
}
