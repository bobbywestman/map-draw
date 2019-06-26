//
//  Canvas+PinOverlay.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/26/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension Canvas {
    func hidePinOverlay() {
        pinOverlay?.removeFromSuperview()
        pinOverlay = nil
    }
    
    func showPinOverlay() {
        
    }
}
