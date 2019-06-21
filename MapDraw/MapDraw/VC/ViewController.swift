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
    // MARK: Map

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapToggleButton: UIButton!

    // MARK: Screenshot

    @IBOutlet weak var saveButton: UIButton!

    // MARK: Drawing
    
    @IBOutlet weak var canvas: Canvas!
    @IBOutlet weak var boxButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var colorPicker: ColorPickerView!
    
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
    override func viewDidLoad() {
        colorPicker.elementSize = 5
        colorPicker.delegate = self

        map.mapType = .hybridFlyover
        // TODO: set map center initially at current location?

        searchBar.delegate = self
        completer.delegate = self

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.isHidden = true

        canvas.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: canvas, action: #selector(Canvas.tapDetected(tapRecognizer:)))
        canvas.addGestureRecognizer(tapRecognizer)
        canvas.drawColor = .black
        canvas.drawingState = .none
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}
