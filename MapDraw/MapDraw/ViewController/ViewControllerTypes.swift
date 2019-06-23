//
//  ViewControllerTypes.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation

/// A type that defines the current state of the application.
enum InteractionState {
    /// User is selecting an area of the map to edit.
    case selection
    
    /// User is drawing on / editing the selected area.
    case drawing
}
