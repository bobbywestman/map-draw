//
//  CanvasModels.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

struct Pin {
    let id: UUID
    var color: UIColor
    var location: CGPoint
    var number: Int?
    var note: String?
    
    init(id: UUID, color: UIColor, location: CGPoint, number: Int? = nil, note: String? = nil) {
        self.id = id
        self.location = location
        self.color = color
        self.number = number
        self.note = note
    }
}

extension Pin: Equatable {
    public static func == (lhs: Pin, rhs: Pin) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        return true
    }
}

// TODO: make this a class, we keep having to update `selectedLine` copy value
struct Line {
    let id: UUID
    var color: UIColor
    var points: [LinePoint]
    var path: UIBezierPath?
    var redoPoints: [LinePoint]
    
    init(id: UUID, points: [LinePoint], color: UIColor, path: UIBezierPath? = nil, redoPoints: [LinePoint] = []) {
        self.id = id
        self.points = points
        self.color = color
        self.path = path
        self.redoPoints = redoPoints
    }
}

extension Line: Equatable {
    public static func == (lhs: Line, rhs: Line) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        return true
    }
}

struct LinePoint {
    let id: UUID
    var location: CGPoint
}

extension LinePoint: Equatable {
    public static func == (lhs: LinePoint, rhs: LinePoint) -> Bool {
        guard lhs.id == rhs.id else {
            return false
        }
        return true
    }
}
