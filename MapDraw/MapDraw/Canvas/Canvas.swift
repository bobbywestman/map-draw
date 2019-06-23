//
//  Canvas.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

class Canvas: UIView {
    weak var delegate: CanvasHandling?
    
    var groups = [PointGroup]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var selectedGroup: PointGroup? {
        didSet {
            setNeedsDisplay()
        }
    }

    var drawingState: DrawingState = .none {
        didSet {
            print(drawingState)
            
            delegate?.drawingChanged(to: drawingState)
        }
    }
    
    var drawColor: UIColor = .black {
        didSet {
            delegate?.colorChanged(to: drawColor)
        }
    }
    
    var dragStartedLocation: CGPoint?
    
    var draggingPoint: Point?
    
    func clearDrawings() {
        groups = []
    }
}
