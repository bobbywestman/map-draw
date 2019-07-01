//
//  ViewController+SearchBar.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {        
        guard let text = searchBar.text, !text.isEmpty else {
            searchResults = []
            return
        }
        completer.queryFragment = text
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchResults.count > 0 else { return }

        searchBar.endEditing(true)
        
        let completion = searchResults[0]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let coordinate = response?.mapItems[0].placemark.coordinate {
                MapHelper.updateMap(self.map, location: coordinate)
                self.searchBar.text = self.searchResults[0].title
                self.searchResults = []
            }
        }
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

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
        
        guard  searchResults.count > 0 else { return }
        searchResults = []
    }
}
