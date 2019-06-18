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
    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var colorPicker: ColorPickerView!

    @IBOutlet weak var boxButton: UIButton!

    @IBOutlet weak var lineButton: UIButton!

    @IBOutlet weak var pinButton: UIButton!

    @IBOutlet weak var mapToggleButton: UIButton!

    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchResultsTableView: UITableView!

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
        }
    }
}

extension ViewController {
    override func viewDidLoad() {
        colorPicker.elementSize = 5
        colorPicker.delegate = self

        map.mapType = .satelliteFlyover
        // TODO: set map center initially at current location

        searchBar.delegate = self

        completer.delegate = self
        // TODO: set completer.region based on current location?
        // Specifying a region does not guarantee that the results will all be inside the region. It is merely a hint to the search engine.

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.isHidden = true
    }
}

extension ViewController {
    @IBAction func boxButtonClick(_ sender: Any) {
        
    }
}

extension ViewController {
    @IBAction func lineButtonClick(_ sender: Any) {
        
    }
}

extension ViewController {
    @IBAction func pinButtonClick(_ sender: Any) {
        
    }
}

extension ViewController {
    @IBAction func mapToggleButtonClick(_ sender: Any) {
        map.mapType = (map.mapType == .satelliteFlyover) ? .hybrid : .satelliteFlyover
    }
}

extension ViewController {
    @IBAction func saveButtonClick(_ sender: Any) {
        
    }
}
