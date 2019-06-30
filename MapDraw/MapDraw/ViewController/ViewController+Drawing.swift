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
    func undoEnabled() {
        // TODO: update undo button
    }
    
    func undoDisabled() {
        // TODO: update undo button
    }
    
    func redoEnabled() {
        // TODO: update redo button
    }
    
    func redoDisabled() {
        // TODO: update redo button
    }
    
    func deleteEnabled() {
        // TODO: update delete button
    }
    
    func deleteDisabled() {
        // TODO: update delete button
    }
    
    func pinValueChanged(to value: Int) {
        pinNumberPicker.selectRow(value, inComponent: 0, animated: true)
    }
    
    func colorChanged(to color: UIColor) {
        drawingChanged(to: canvas.drawingState)
    }
    
    func drawingChanged(to state: DrawingState) {
        let darkTransparent = ViewController.darkTransparent
        
        let drawColor = canvas.drawColor
        let drawColorLighter = canvas.drawColor.lighter().lighter()
        
        lineButton.tintColor = drawColorLighter
        lineButton.layer.borderColor = drawColorLighter.cgColor
        lineButton.backgroundColor = .clear
        
        boxButton.tintColor = drawColorLighter
        boxButton.layer.borderColor = drawColorLighter.cgColor
        boxButton.backgroundColor = .clear

        pinButton.tintColor = drawColorLighter
        pinButton.layer.borderColor = drawColorLighter.cgColor
        pinButton.backgroundColor = .clear
        
        // Hue values 0.0 & 1.0 are the same color for some reason.
        // Don't update slider position if positioned at either end and the same color is chosen.
        // If you don't do this, dragging the slider to it's right edge (value == 1.0) makes it jump back to the left edge (value == 0.0)
        // TODO: one possible way to solve this is making slider min = 0.0, slider max = 1.0 - (smallest possible float value)... but even then it might not work based on how the hue is calculated if there's any rounding involved
        let hue = drawColor.hsba.h
        if !(colorSlider.value == 1.0 && hue == 0.0 || colorSlider.value == 0.0 && hue == 1.0) {
            colorSlider.value = Float(hue)
            updateSliderColor(drawColor)
        }
        
        switch state {
        case .line:
            lineButton.tintColor = canvas.drawColor
            lineButton.layer.borderColor = drawColor.cgColor
            lineButton.backgroundColor = darkTransparent
        case .box:
            boxButton.tintColor = canvas.drawColor
            boxButton.layer.borderColor = drawColor.cgColor
            boxButton.backgroundColor = darkTransparent
        case .pin:
            pinButton.tintColor = canvas.drawColor
            pinButton.layer.borderColor = drawColor.cgColor
            pinButton.backgroundColor = darkTransparent
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
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        drawingDelegate?.deleteSelected()
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
        let color = UIColor(hue: CGFloat(sender.value), saturation: 1.0, brightness: 0.7, alpha: 1.0)
        updateSliderColor(color)
        drawingDelegate?.setColor(color)
    }
    
    func updateSliderColor(_ color: UIColor) {
        colorSlider.thumbTintColor = color.lighter().lighter()
        colorSlider.minimumTrackTintColor = color
        colorSlider.maximumTrackTintColor = color
    }
}
