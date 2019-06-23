//
//  ViewController.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    // MARK: Title

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Map

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapToggleButton: UIButton!

    // MARK: Screenshot

    @IBOutlet weak var saveButton: UIButton!

    // MARK: State
    
    var interactionState: InteractionState = .selection {
        didSet {
            switch interactionState {
            case .selection:
                canvas.drawingState = .none
                canvas.clearDrawings()
                canvas.isHidden = true
                drawingPanel.isHidden = true
                
                selectorView.isHidden = true // this is visible on button tap, not state change
                selectionImageView.isHidden = true // this is visible on button tap, not state change
                selectionImageView.image = nil
                selectionPanel.isHidden = false
                
                saveButton.isHidden = true
                cancelDrawingButton.isHidden = true
                
                searchBar.isHidden = false
                mapToggleButton.isHidden = false
                titleLabel.isHidden = false
            case .drawing:
                canvas.isHidden = false
                drawingPanel.isHidden = false
                
                selectorView.isHidden = true
                selectionImageView.isHidden = false
                selectionPanel.isHidden = true
                
                saveButton.isHidden = false
                cancelDrawingButton.isHidden = false

                searchBar.isHidden = true
                mapToggleButton.isHidden = true
                titleLabel.isHidden = true
            }
        }
    }
    
    // MARK: Selection
    
    /// The view in which the selection will be made.
    @IBOutlet weak var selectorView: ResizableView!
    
    /// The view containing the image of the selection.
    @IBOutlet weak var selectionImageView: UIImageView!
    
    /// The bottom panel with interactive elements for selecting a section of the map to draw on.
    @IBOutlet weak var selectionPanel: UIView!
    
    /// The button to select a section of the map.
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: Drawing
    
    /// The bottom panel with interactive elements for drawing.
    @IBOutlet weak var drawingPanel: UIView!
    @IBOutlet weak var canvas: Canvas!
    @IBOutlet weak var boxButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var colorPicker: ColorPickerView!
    @IBOutlet weak var cancelDrawingButton: UIButton!
    
    // MARK: Search

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let completer = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]() {
        didSet {
            guard searchResults.count > 0 else {
                searchResultsTableView.isHidden = true
                searchBar.resignFirstResponder
                searchBar.endEditing(true)
                return
            }
            searchResultsTableView.isHidden = false
            searchResultsTableView.reloadData()
            
            tableViewHeight.constant = 200
            searchResultsTableView.layoutIfNeeded()
            var height: CGFloat = 0.0
            for cell in searchResultsTableView.visibleCells {
                height += cell.frame.height
            }
            tableViewHeight.constant = min(200, height)
        }
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}
