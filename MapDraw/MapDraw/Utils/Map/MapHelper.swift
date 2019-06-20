//
//  MapHelper.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import MapKit

class MapHelper {
    static func updateMap(_ map: MKMapView, location: CLLocationCoordinate2D) {
        let camera = MKMapCamera(lookingAtCenter: location, fromEyeCoordinate: location, eyeAltitude: 1)
        map.setCamera(camera, animated: true)
    }
}
