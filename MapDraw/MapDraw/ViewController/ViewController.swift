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

    /// Label with app title.
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Map

    /// Map.
    @IBOutlet weak var map: MKMapView!
    
    /// Button that toggles map type / information.
    @IBOutlet weak var mapToggleButton: UIButton!

    // MARK: Screenshot

    /// Button that triggers an alert prompting user to save a screenshot to the camera roll.
    @IBOutlet weak var saveButton: UIButton!
    
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
    @IBOutlet weak var canvas: Canvas!
    weak var drawingDelegate: Canvasing?
    
    @IBOutlet weak var drawingPanel: UIView!
    @IBOutlet weak var boxButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var cancelDrawingButton: UIButton!
    
    // MARK: Color Picker
    
    @IBOutlet weak var colorSlider: ColorSlider!
    
    // MARK: Pin Number Picker
    
    @IBOutlet weak var pinNumberPicker: OrientablePickerView!
    
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
    
    // MARK: State
    
    /// State that defines what "mode" the user is currently interacting with.
    /// When changing modes, hide / show relevant views.
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
}
