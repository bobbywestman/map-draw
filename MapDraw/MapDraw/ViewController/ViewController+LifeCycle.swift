//
//  ViewController+LifeCycle.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    override func viewDidLoad() {
        map.mapType = .hybrid
        
        searchBar.delegate = self
        completer.delegate = self
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.isHidden = true
        
        canvas.delegate = self
        drawingDelegate = canvas
        drawingDelegate?.setColor(.black)
        canvas.drawingState = .none
        canvas.clipsToBounds = true
        
        let canvasTapRecognizer = UITapGestureRecognizer(target: canvas, action: #selector(Canvas.handleTap(recognizer:)))
        let canvasPanRecognizer = UIPanGestureRecognizer(target: canvas, action: #selector(Canvas.handlePan(recognizer:)))
        canvas.addGestureRecognizer(canvasTapRecognizer)
        canvas.addGestureRecognizer(canvasPanRecognizer)
        
        // update slider color
        colorSlider.value = 0.0
        colorSliderValueChanged(colorSlider)
        
        selectorView.backgroundColor = .clear
        selectorView.boundingView = map
                
        let selectorPanRecognizer = UIPanGestureRecognizer(target: selectorView, action: #selector(ResizableView.handlePan(recognizer:)))
        let selectorPinchRecognizer = UIPinchGestureRecognizer(target: selectorView, action: #selector(ResizableView.handlePinch(recognizer:)))
        let selectorRotationRecognizer = UIRotationGestureRecognizer(target: selectorView, action: #selector(ResizableView.handleRotation(recognizer:)))
        selectorView.addGestureRecognizer(selectorPanRecognizer)
        selectorView.addGestureRecognizer(selectorPinchRecognizer)
        selectorView.addGestureRecognizer(selectorRotationRecognizer)
        
        pinNumberPicker.delegate = self
        pinNumberPicker.dataSource = self
        pinNumberPicker.orientation = .horizontal
        
        setupStyles()
        
        interactionState = .selection
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectorView.aspectRatio =  CGHelper.aspectRatio(width: map.frame.width, height: map.frame.height)
        selectorView.addExternalBorder(5.0, .white)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super .viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.resetSelectorPosition()
        })
    }
}

extension ViewController {
    func setupStyles() {
        let dark = ViewController.dark
        let light = ViewController.light
        let darkTransparent = ViewController.darkTransparent
        let borderWidth = ViewController.borderWidth
        let cornerRadius = ViewController.cornerRadius
        
        UITextField.appearance(whenContainedInInstancesOf:
            [UISearchBar.self]).textColor = light
        
        background.blur(.regular, intensity: 0.3)
        drawingPanel.backgroundColor = .clear
        selectionPanel.backgroundColor = .clear
        headerPanel.backgroundColor = .clear
        
        titleLabel.textColor = light
        selectionNoteLabel.textColor = light
        
        undoButton.setTitleColor(light, for: .normal)
        undoButton.tintColor = light
        undoButton.backgroundColor = darkTransparent
        undoButton.layer.borderColor = dark.cgColor
        undoButton.layer.borderWidth = borderWidth
        undoButton.layer.cornerRadius = cornerRadius
        
        redoButton.setTitleColor(light, for: .normal)
        redoButton.tintColor = light
        redoButton.backgroundColor = darkTransparent
        redoButton.layer.borderColor = dark.cgColor
        redoButton.layer.borderWidth = borderWidth
        redoButton.layer.cornerRadius = cornerRadius
        
        clearButton.setTitleColor(light, for: .normal)
        clearButton.tintColor = light
        clearButton.backgroundColor = darkTransparent
        clearButton.layer.borderColor = dark.cgColor
        clearButton.layer.borderWidth = borderWidth
        clearButton.layer.cornerRadius = cornerRadius
        
        pinButton.setTitleColor(light, for: .normal)
        pinButton.backgroundColor = darkTransparent
        pinButton.layer.borderColor = light.cgColor
        pinButton.layer.borderWidth = borderWidth
        pinButton.layer.cornerRadius = cornerRadius
        
        lineButton.setTitleColor(light, for: .normal)
        lineButton.backgroundColor = darkTransparent
        lineButton.layer.borderColor = light.cgColor
        lineButton.layer.borderWidth = borderWidth
        lineButton.layer.cornerRadius = cornerRadius
        
        boxButton.setTitleColor(light, for: .normal)
        boxButton.backgroundColor = darkTransparent
        boxButton.layer.borderColor = light.cgColor
        boxButton.layer.borderWidth = borderWidth
        boxButton.layer.cornerRadius = cornerRadius
        
        mapToggleButton.setTitleColor(light, for: .normal)
        mapToggleButton.backgroundColor = darkTransparent
        mapToggleButton.layer.borderColor = dark.cgColor
        mapToggleButton.layer.borderWidth = borderWidth
        mapToggleButton.layer.cornerRadius = cornerRadius
        
        saveButton.setTitleColor(light, for: .normal)
        saveButton.backgroundColor = darkTransparent
        saveButton.layer.borderColor = dark.cgColor
        saveButton.layer.borderWidth = borderWidth
        saveButton.layer.cornerRadius = cornerRadius
        
        cancelDrawingButton.setTitleColor(light, for: .normal)
        cancelDrawingButton.backgroundColor = darkTransparent
        cancelDrawingButton.layer.borderColor = dark.cgColor
        cancelDrawingButton.layer.borderWidth = borderWidth
        cancelDrawingButton.layer.cornerRadius = cornerRadius
        
        selectButton.setTitleColor(light, for: .normal)
        selectButton.backgroundColor = darkTransparent
        selectButton.layer.borderColor = dark.cgColor
        selectButton.layer.borderWidth = borderWidth
        selectButton.layer.cornerRadius = cornerRadius
        
        uploadButton.setTitleColor(light, for: .normal)
        uploadButton.backgroundColor = darkTransparent
        uploadButton.layer.borderColor = dark.cgColor
        uploadButton.layer.borderWidth = borderWidth
        uploadButton.layer.cornerRadius = cornerRadius
    }
}
