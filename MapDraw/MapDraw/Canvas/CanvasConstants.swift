//
//  CanvasConstants.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

/// Constants used to define thresholds for detecting line point locations.
extension Canvas {
    /// When tapping a line, this threshold determines the size of the area in which a hit will be detected on the line path.
    static let kLineTapThreshold = CGFloat(60)
    
    /// When dragging / moving line points, this threshold determines the size of the area in which a point will detect a "hit" and be moved.
    static let kLinePointTapThreshold = CGFloat(40)
    
    /// When adding new line points, this threshold determines the size of the area in which a point will "connect" with the first point on the line, to create a closed / completed path.
    static let kLinePointConnectThreshold = CGFloat(30)
    
    /// When dragging or tapping pins, this threshold determines the size of the area in which a pin will detect a "hit".
    static let kPinTapThreshold = CGFloat(40)
    
    /// When dragging an element, the user's finger covers the exact location, this offest makes it a bit easier to see where exactly the element is being moved to.
    static let kDragVerticalOffset = CGFloat(10)
    
    /// When dragging an element, the user's finger covers the exact location, this offest makes it a bit easier to see where exactly the element is being moved to.
    static let kDragHorizontalOffset = CGFloat(45)
    
    static let kPinHeight = CGFloat(31.2)
    static let kPinWidth = CGFloat(21.775)
    
    static let kLinePointDiameter = CGFloat(8)
    static let kLineWidth = CGFloat(5)
}
