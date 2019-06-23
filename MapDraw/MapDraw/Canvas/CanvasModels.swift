//
//  CanvasModels.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

// TODO: make this a class, we keep having to update selected group copy value
struct PointGroup {
    let id: UUID
    let color: UIColor
    var points: [Point]
    var path: UIBezierPath?
    var redoPoints: [Point]
    
    init(id: UUID, points: [Point], color: UIColor, path: UIBezierPath? = nil, redoPoints: [Point] = []) {
        self.id = id
        self.points = points
        self.color = color
        self.path = path
        self.redoPoints = redoPoints
    }
}

extension PointGroup: Equatable {
    public static func == (lhs: PointGroup, rhs: PointGroup) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        return true
    }
}

struct Point {
    let id: UUID
    var location: CGPoint
}

extension Point: Equatable {
    public static func == (lhs: Point, rhs: Point) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        return true
    }
}
