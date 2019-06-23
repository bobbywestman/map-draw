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
        map.mapType = .hybridFlyover
        // TODO: set map center initially at current location?
        
        searchBar.delegate = self
        completer.delegate = self
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.isHidden = true
        
        canvas.drawColor = .black
        canvas.drawingState = .none
        canvas.delegate = self
        
        let canvasTapRecognizer = UITapGestureRecognizer(target: canvas, action: #selector(Canvas.handleTap(recognizer:)))
        let canvasDragRecognizer = UIPanGestureRecognizer(target: canvas, action: #selector(Canvas.handleDrag(recognizer:)))
        canvas.addGestureRecognizer(canvasTapRecognizer)
        canvas.addGestureRecognizer(canvasDragRecognizer)
        
        colorPicker.elementSize = 27
        colorPicker.delegate = self
        
        interactionState = .selection
        
        selectorView.addExternalBorder(5.0, .white)
        selectorView.backgroundColor = .clear
    }
}
