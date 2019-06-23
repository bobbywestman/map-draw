//
//  ResizableViewTypes.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/23/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation

/// A type defining the location of a pan gesture inside of a ResizableView.
enum ResizableViewPanGestureLocation {
    /// The pan gesture was started in the top left corner
    case topLeft
    
    /// The pan gesture was started in the top right corner
    case topRight
    
    /// The pan gesture was started in the bottom right corner
    case bottomright
    
    /// The pan gesture was started in the bottom left corner
    case bottomLeft
    
    /// The pan gesture was started anywhere other than the corners
    case center
}
