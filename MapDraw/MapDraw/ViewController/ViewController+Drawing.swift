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
    func colorChanged(to color: UIColor) {
        drawingChanged(to: canvas.drawingState)
    }
    
    func drawingChanged(to state: DrawingState) {
        lineButton.tintColor = canvas.drawColor.lighter().lighter()
        lineButton.layer.borderColor = canvas.drawColor.lighter().lighter().cgColor
        
        boxButton.tintColor = canvas.drawColor.lighter().lighter()
        boxButton.layer.borderColor = canvas.drawColor.lighter().lighter().cgColor

        pinButton.tintColor = canvas.drawColor.lighter().lighter()
        pinButton.layer.borderColor = canvas.drawColor.lighter().lighter().cgColor
        
        switch state {
        case .line:
            lineButton.tintColor = canvas.drawColor
            lineButton.layer.borderColor = canvas.drawColor.cgColor
        case .box:
            boxButton.tintColor = canvas.drawColor
            boxButton.layer.borderColor = canvas.drawColor.cgColor
        case .pin:
            pinButton.tintColor = canvas.drawColor
            pinButton.layer.borderColor = canvas.drawColor.cgColor
        case .none:
            break
        }
    }
}

extension ViewController {
    @IBAction func boxButtonClick(_ sender: Any) {
        drawingDelegate?.drawingBox()
    }

    @IBAction func lineButtonClick(_ sender: Any) {
        drawingDelegate?.drawingLine()
    }

    @IBAction func pinButtonClick(_ sender: Any) {
        drawingDelegate?.drawingPin()
    }
}

extension ViewController {
    @IBAction func undoButtonClick(_ sender: Any) {
        drawingDelegate?.undo()
    }
    
    @IBAction func redoButtonClick(_ sender: Any) {
        drawingDelegate?.redo()
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        guard canvas.pins.count > 0 || canvas.lines.count > 0 else { return }
        
        let alert = UIAlertController(title: "Clear Edits", message: "Are you sure?\nYour changes won't be saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            self.drawingDelegate?.clear()
        })
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    @IBAction func cancelDrawingButtonClick(_ sender: Any) {
        guard canvas.pins.count > 0 || canvas.lines.count > 0 else {
            interactionState = .selection
            return
        }
        
        let alert = UIAlertController(title: "Cancel", message: "Are you sure?\nYour changes won't be saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            self.interactionState = .selection
        })
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    @IBAction func colorSliderValueChanged(_ sender: UISlider) {
        let color = UIColor(hue: CGFloat(sender.value), saturation: 1.0, brightness: 0.55, alpha: 1.0)
        sender.thumbTintColor = color.lighter().lighter()
        sender.minimumTrackTintColor = color
        sender.maximumTrackTintColor = color
        drawingDelegate?.setColor(color)
    }
}
