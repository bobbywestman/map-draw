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
