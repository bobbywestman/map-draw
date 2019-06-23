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
    
    var lines = [Line]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var selectedLine: Line? {
        didSet {
            setNeedsDisplay()
        }
    }

    var pins = [Pin]() {
        didSet {
            updatePinImages()
        }
    }
    
    var pinImages = [UIImageView]()
    
    var selectedPin: Pin? {
        didSet {
            updatePinImages()
        }
    }
    
    var drawingState: DrawingState = .none {
        didSet {
            print("Drawing state: \(drawingState)")
            
            delegate?.drawingChanged(to: drawingState)
        }
    }
    
    var drawColor: UIColor = .black {
        didSet {
            delegate?.colorChanged(to: drawColor)
        }
    }
    
    var draggingPoint: LinePoint?
    var draggingPin: Pin?
}
