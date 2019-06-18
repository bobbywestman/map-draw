//
//  ViewController+SearchBar.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {        
        guard let text = searchBar.text, !text.isEmpty else {
            searchResults = []
            return
        }
        completer.queryFragment = text
    }
}
