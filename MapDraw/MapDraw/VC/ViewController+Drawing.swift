//
//  ViewController+Drawing.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: CanvasHandling {
    func drawingChanged(to state: DrawingState) {
        boxButton.backgroundColor = canvas.drawColor.lighter().lighter()
        lineButton.backgroundColor = canvas.drawColor.lighter().lighter()
        pinButton.backgroundColor = canvas.drawColor.lighter().lighter()
        
        switch state {
        case .line:
            lineButton.backgroundColor = canvas.drawColor
        case .box:
            boxButton.backgroundColor = canvas.drawColor
        case .pin:
            pinButton.backgroundColor = canvas.drawColor
        case .none:
            break
        }
    }
}

extension ViewController {
    @IBAction func boxButtonClick(_ sender: Any) {
        switch canvas.drawingState {
        case .box:
            canvas.drawingState = .none
        default:
            canvas.drawingState = .box
        }
    }
}

extension ViewController {
    @IBAction func lineButtonClick(_ sender: Any) {
        switch canvas.drawingState {
        case .line:
            canvas.drawingState = .none
            canvas.selectedGroup = nil
        default:
            canvas.drawingState = .line
        }
    }
}

extension ViewController {
    @IBAction func pinButtonClick(_ sender: Any) {
        switch canvas.drawingState {
        case .pin:
            canvas.drawingState = .none
        default:
            canvas.drawingState = .pin
        }
    }
}

extension ViewController {
    @IBAction func undoButtonClick(_ sender: Any) {
        guard let selectedGroup = canvas.selectedGroup, selectedGroup.points.count > 0 else {
            return
        }
        
        if let index = canvas.groups.index(of: selectedGroup),
            let lastPoint = canvas.groups[index].points.last {
            canvas.groups[index].redoPoints.append(lastPoint)

            canvas.groups[index].points.removeLast()
        }
    }
    
    @IBAction func redoButtonClick(_ sender: Any) {
        guard let selectedGroup = canvas.selectedGroup else {
            return
        }
        
        if let index = canvas.groups.index(of: selectedGroup),
            let lastPoint = canvas.groups[index].redoPoints.last {
            canvas.groups[index].points.append(lastPoint)
            
            canvas.groups[index].redoPoints.removeLast()
        }
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        canvas.groups = []
    }
}
