//
//  ViewController+SizeClasses.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/26/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    override var traitCollection: UITraitCollection {
        // handle size classes for portrait ipad
        if UIDevice.current.userInterfaceIdiom == .pad,
            view.bounds.width < view.bounds.height {
            let traits = [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)]
            return UITraitCollection(traitsFrom: traits)
        }
        
        return super.traitCollection
    }
}
