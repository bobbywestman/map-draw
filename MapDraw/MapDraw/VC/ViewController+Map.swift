//
//  ViewController+Map.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import MapKit

extension ViewController {
    @IBAction func mapToggleButtonClick(_ sender: Any) {
        map.mapType = (map.mapType == .satelliteFlyover) ? .hybridFlyover : .satelliteFlyover
        
        let text =  (mapToggleButton.titleLabel?.text == "Show Map Info") ? "Hide Map Info" : "Show Map Info"
        mapToggleButton.setTitle(text, for: .normal)
    }
}

extension ViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // there is a delay for showing results, so if we clear text in search bar, results may still show
        // only display results if there is still text in the search bar
        guard let text = searchBar.text, !text.isEmpty else {
            searchResults = []
            return
        }
        searchResults = completer.results
    }
}
