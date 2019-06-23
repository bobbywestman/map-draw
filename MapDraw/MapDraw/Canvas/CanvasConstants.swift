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
    /// When dragging / moving line points, this threshold determines the size of the area in which a point will detect a "hit" and be moved.
    static let kPointTapThreshold = CGFloat(20)
    
    /// When adding new line points, this threshold determines the size of the area in which a point will "connect" with the first point on the line, to create a closed / completed path.
    static let kPointConnectThreshold = CGFloat(20)
}
