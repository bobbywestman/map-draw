//
//  ViewController+SearchTable.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else {
            return 0
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.section]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        cell.backgroundColor = ViewController.heavyMediumTransparent
        cell.layer.cornerRadius = ViewController.cornerRadius
        cell.textLabel?.textColor = ViewController.light.darker()
        cell.detailTextLabel?.textColor = ViewController.light.darker()
        
        // TODO: update hardcoded fonts -> UIFont.preferredFont(forTextStyle: )
        cell.textLabel?.attributedText = TextHelper.highlightedText(searchResult.title, inRanges: searchResult.titleHighlightRanges, size: 17.0, color: ViewController.light)
        cell.detailTextLabel?.attributedText = TextHelper.highlightedText(searchResult.subtitle, inRanges: searchResult.subtitleHighlightRanges, size: 12.0, color: ViewController.light)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let self = self else { return }

            if let coordinate = response?.mapItems[0].placemark.coordinate {
                MapHelper.updateMap(self.map, location: coordinate)
                self.searchBar.text = self.searchResults[indexPath.row].title
                self.searchResults = []
            }
        }
    }
}
