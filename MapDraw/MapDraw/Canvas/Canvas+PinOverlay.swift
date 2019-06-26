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
    
    func showPinOverlay(on pin: Pin) {
        hidePinOverlay()
        
        addOverlay()
        
        guard let overlay = pinOverlay else { return }
        
        verifyPosition(of: overlay, in: self)
    }

    func addOverlay() {
        pinOverlay = UIView()
        
    }
    
    func verifyPosition(of overlay: UIView, in boundingView: UIView) {
        
    }
}
