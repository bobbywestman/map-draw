//
//  CanvasModels.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

enum DrawingState {
    case line
    case box
    case pin
    case none
}

// TODO: make this a class, we keep having to update selected group copy value
struct PointGroup {
    var id: UUID
    var points: [CGPoint]
    var color: UIColor
    var path: UIBezierPath?
    var redoPoints: [CGPoint]
    
    init(id: UUID, points: [CGPoint], color: UIColor, path: UIBezierPath? = nil, redoPoints: [CGPoint] = []) {
        self.id = id
        self.points = points
        self.color = color
        self.path = path
        self.redoPoints = redoPoints
    }
}

extension PointGroup: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: PointGroup, rhs: PointGroup) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        return true
    }
}
