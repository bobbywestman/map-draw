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
        
        background.addBlur(.regular)
        drawingPanel.backgroundColor = .clear
        selectionPanel.backgroundColor = .clear
        headerPanel.backgroundColor = .clear
        
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
