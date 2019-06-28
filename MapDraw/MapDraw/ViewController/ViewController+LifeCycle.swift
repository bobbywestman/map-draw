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
        let dark = UIColor.gray
        let light = UIColor.white
        let darkTransparent = dark.withAlphaComponent(0.3)
        let lightTransparent = light.withAlphaComponent(0.3)

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
        undoButton.layer.borderWidth = 2.0
        undoButton.layer.cornerRadius = 15.0
        
        redoButton.setTitleColor(light, for: .normal)
        redoButton.tintColor = light
        redoButton.backgroundColor = darkTransparent
        redoButton.layer.borderColor = dark.cgColor
        redoButton.layer.borderWidth = 2.0
        redoButton.layer.cornerRadius = 15.0
        
        clearButton.setTitleColor(light, for: .normal)
        clearButton.tintColor = light
        clearButton.backgroundColor = darkTransparent
        clearButton.layer.borderColor = dark.cgColor
        clearButton.layer.borderWidth = 2.0
        clearButton.layer.cornerRadius = 15.0
        
        pinButton.setTitleColor(light, for: .normal)
        pinButton.backgroundColor = lightTransparent
        pinButton.layer.borderColor = light.cgColor
        pinButton.layer.borderWidth = 2.0
        pinButton.layer.cornerRadius = 15.0
        
        lineButton.setTitleColor(light, for: .normal)
        lineButton.backgroundColor = lightTransparent
        lineButton.layer.borderColor = light.cgColor
        lineButton.layer.borderWidth = 2.0
        lineButton.layer.cornerRadius = 15.0
        
        boxButton.setTitleColor(light, for: .normal)
        boxButton.backgroundColor = lightTransparent
        boxButton.layer.borderColor = light.cgColor
        boxButton.layer.borderWidth = 2.0
        boxButton.layer.cornerRadius = 15.0
        
        mapToggleButton.setTitleColor(light, for: .normal)
        mapToggleButton.backgroundColor = darkTransparent
        mapToggleButton.layer.borderColor = dark.cgColor
        mapToggleButton.layer.borderWidth = 2.0
        mapToggleButton.layer.cornerRadius = 15.0
        
        saveButton.setTitleColor(light, for: .normal)
        saveButton.backgroundColor = darkTransparent
        saveButton.layer.borderColor = dark.cgColor
        saveButton.layer.borderWidth = 2.0
        saveButton.layer.cornerRadius = 15.0
        
        cancelDrawingButton.setTitleColor(light, for: .normal)
        cancelDrawingButton.backgroundColor = darkTransparent
        cancelDrawingButton.layer.borderColor = dark.cgColor
        cancelDrawingButton.layer.borderWidth = 2.0
        cancelDrawingButton.layer.cornerRadius = 15.0
        
        selectButton.setTitleColor(light, for: .normal)
        selectButton.backgroundColor = darkTransparent
        selectButton.layer.borderColor = dark.cgColor
        selectButton.layer.borderWidth = 2.0
        selectButton.layer.cornerRadius = 15.0
    }
}
