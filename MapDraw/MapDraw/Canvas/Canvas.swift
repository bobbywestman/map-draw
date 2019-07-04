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
    
    var drawingState: DrawingState = .none {
        didSet {            
            delegate?.drawingChanged(to: drawingState)
        }
    }
    
    var drawColor: UIColor = .black {
        didSet {
            delegate?.colorChanged(to: drawColor)
        }
    }
    
    var pinLabel: String = "" {
        didSet {
            delegate?.pinLabelChanged(to: pinLabel)
        }
    }
    
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
    
    var selectedText: Text? {
        didSet {
            updateTextLabels()
        }
    }

    var pins = [Pin]() {
        didSet {
            updatePinImages()
        }
    }
    
    var texts = [Text]() {
        didSet {
            updateTextLabels()
        }
    }
    
    var selectedPin: Pin? {
        didSet {
            updatePinImages()
            
            guard let selectedPin = selectedPin else { return }
            
            pinLabel = selectedPin.label
        }
    }
    
    var pinImages = [UIImageView]()
    var labels = [UILabel]()
    
    var draggingPoint: LinePoint?
    var draggingPin: Pin?
    var draggingText: Text?
    
    var pinOverlay: UIView?
    
    var undoStore = [CanvasState]()
    var redoStore = [CanvasState]()
}
