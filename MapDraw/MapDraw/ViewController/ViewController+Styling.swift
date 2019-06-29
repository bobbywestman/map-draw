//
//  ViewController+Styling.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/28/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController {
    func setupStyles() {
        let dark = ViewController.dark
        let light = ViewController.light
        let borderWidth = ViewController.borderWidth
        let cornerRadius = ViewController.cornerRadius
        
        UITextField.appearance(whenContainedInInstancesOf:
            [UISearchBar.self]).textColor = light
        searchResultsTableView.backgroundColor = .clear
        
        background.blur(.regular, intensity: 0.3)
        
        drawingPanel.backgroundColor = .clear
        selectionPanel.backgroundColor = .clear
        headerPanel.backgroundColor = .clear
        
        titleLabel.textColor = light
        selectionNoteLabel.textColor = light
        
        undoButton.setTitleColor(light, for: .normal)
        undoButton.tintColor = light
        undoButton.backgroundColor = .clear
        undoButton.layer.borderColor = dark.cgColor
        undoButton.layer.borderWidth = borderWidth
        undoButton.layer.cornerRadius = cornerRadius
        
        redoButton.setTitleColor(light, for: .normal)
        redoButton.tintColor = light
        redoButton.backgroundColor = .clear
        redoButton.layer.borderColor = dark.cgColor
        redoButton.layer.borderWidth = borderWidth
        redoButton.layer.cornerRadius = cornerRadius
        
        clearButton.setTitleColor(light, for: .normal)
        clearButton.tintColor = light
        clearButton.backgroundColor = .clear
        clearButton.layer.borderColor = dark.cgColor
        clearButton.layer.borderWidth = borderWidth
        clearButton.layer.cornerRadius = cornerRadius
        
        pinButton.setTitleColor(light, for: .normal)
        pinButton.backgroundColor = .clear
        pinButton.layer.borderColor = light.cgColor
        pinButton.layer.borderWidth = borderWidth
        pinButton.layer.cornerRadius = cornerRadius
        
        lineButton.setTitleColor(light, for: .normal)
        lineButton.backgroundColor = .clear
        lineButton.layer.borderColor = light.cgColor
        lineButton.layer.borderWidth = borderWidth
        lineButton.layer.cornerRadius = cornerRadius
        
        boxButton.setTitleColor(light, for: .normal)
        boxButton.backgroundColor = .clear
        boxButton.layer.borderColor = light.cgColor
        boxButton.layer.borderWidth = borderWidth
        boxButton.layer.cornerRadius = cornerRadius
        
        mapToggleButton.setTitleColor(light, for: .normal)
        mapToggleButton.backgroundColor = .clear
        mapToggleButton.layer.borderColor = dark.cgColor
        mapToggleButton.layer.borderWidth = borderWidth
        mapToggleButton.layer.cornerRadius = cornerRadius
        
        saveButton.setTitleColor(light, for: .normal)
        saveButton.backgroundColor = .clear
        saveButton.layer.borderColor = dark.cgColor
        saveButton.layer.borderWidth = borderWidth
        saveButton.layer.cornerRadius = cornerRadius
        
        cancelDrawingButton.setTitleColor(light, for: .normal)
        cancelDrawingButton.backgroundColor = .clear
        cancelDrawingButton.layer.borderColor = dark.cgColor
        cancelDrawingButton.layer.borderWidth = borderWidth
        cancelDrawingButton.layer.cornerRadius = cornerRadius
        
        selectButton.setTitleColor(light, for: .normal)
        selectButton.backgroundColor = .clear
        selectButton.layer.borderColor = dark.cgColor
        selectButton.layer.borderWidth = borderWidth
        selectButton.layer.cornerRadius = cornerRadius
        
        uploadButton.setTitleColor(light, for: .normal)
        uploadButton.backgroundColor = .clear
        uploadButton.layer.borderColor = dark.cgColor
        uploadButton.layer.borderWidth = borderWidth
        uploadButton.layer.cornerRadius = cornerRadius
    }
}
