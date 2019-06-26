//
//  ViewController+Orientation.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/26/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // restrict iphone to portrait
            return .portrait
        case .pad:
            switch interactionState {
            case .selection:
                return .all
            case .drawing:
                switch UIApplication.shared.statusBarOrientation {
                case .landscapeLeft:
                    return .landscape
                case .landscapeRight:
                    return .landscape
                case .portrait:
                    return .portrait
                case .portraitUpsideDown:
                    // looks like this isnt ever called, not a big deal though, screen will be locked to portrait
                    return .portrait
                default:
                    return .landscape
                }
            }
        default:
            return .landscape
        }
    }
}
