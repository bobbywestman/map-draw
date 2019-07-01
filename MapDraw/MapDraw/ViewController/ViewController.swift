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
    
    // MARK: Header
    
    @IBOutlet weak var headerPanel: UIView!
    
    // MARK: Background
    
    /// Background image.
    @IBOutlet weak var background: UIImageView!
    
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
    
    @IBOutlet weak var selectionNoteLabel: UILabel!
    
    /// The view containing the image of the selection.
    @IBOutlet weak var selectionImageView: UIImageView!
    
    @IBOutlet weak var selectionImageTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var selectionImageLeading: NSLayoutConstraint!
    
    @IBOutlet weak var selectionImageTop: NSLayoutConstraint!
    
    @IBOutlet weak var selectionImageBottom: NSLayoutConstraint!
    
    /// The bottom panel with interactive elements for selecting a section of the map to draw on.
    @IBOutlet weak var selectionPanel: UIView!
    
    /// The button to select a section of the map.
    @IBOutlet weak var selectButton: UIButton!
    
    /// The button to upload an image to edit.
    @IBOutlet weak var uploadButton: UIButton!
    
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
    @IBOutlet weak var cancelDrawingButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: Color Picker
    
    @IBOutlet weak var colorSlider: ColorSlider!
    
    // MARK: Pin Number Picker
    
    @IBOutlet weak var pinLabelPicker: OrientablePickerView!
    
    // MARK: Search

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let completer = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]() {
        didSet {
            guard searchResults.count > 0 else {
                searchResultsTableView.isHidden = true
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
                
                map.isHidden = false
                
                selectionImageLeading.constant = 0
                selectionImageTop.constant = 0
                selectionImageTrailing.constant = 0
                selectionImageBottom.constant = 0
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
                
                map.isHidden = true
                
                guard let image = selectionImageView.image else {
                    selectionImageLeading.constant = 0
                    selectionImageTop.constant = 0
                    selectionImageTrailing.constant = 0
                    selectionImageBottom.constant = 0
                    return
                }
                
                // image is set to aspect-fit
                // need to calculate the transformed size of the image, so that we can resize the canvas around the image. don't want to be drawing out of bounds of the selected image.
                //
                let boundingSize = selectionImageView.bounds.size
                let imageSize = image.size
                
                // calculate transformation scale from aspect-fit sizing
                var scale = boundingSize.width / imageSize.width
                if (boundingSize.height / imageSize.height < scale) {
                    scale = boundingSize.height / imageSize.height
                }
                
                // get actual size of image after transform
                let transformedImageSize = CGSize(width: scale * imageSize.width, height: scale * imageSize.height)

                var horizontalOffset = CGFloat(0)
                var verticalOffset = CGFloat(0)
                var delta = CGFloat(0)
                
                if transformedImageSize.width < boundingSize.width {
                    delta = boundingSize.width - transformedImageSize.width
                    horizontalOffset = delta / 2
                }
                
                if transformedImageSize.height < boundingSize.height {
                    delta = boundingSize.height - transformedImageSize.height
                    verticalOffset = delta / 2
                }
                
                // update contraint contents to fill empty space
                selectionImageLeading.constant = horizontalOffset
                selectionImageTop.constant = verticalOffset
                selectionImageTrailing.constant = -horizontalOffset
                selectionImageBottom.constant = -verticalOffset
            }
        }
    }
}
