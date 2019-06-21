//
//  CanvasModels.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

struct PointGroup {
    var id: UUID
    var points: [CGPoint]
    var color: UIColor
    var path: UIBezierPath?
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
