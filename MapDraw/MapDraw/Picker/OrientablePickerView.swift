//
//  OrientablePickerView.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/27/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

enum Orientation {
    case horizontal
    case vertical
}

// TODO: rip this out and move to VC? VC is handling rotations of the labels anyway... hmmm or try to bring that in here? idk
class OrientablePickerView: UIPickerView {
    var orientation = Orientation.vertical {
        didSet {
            switch orientation {
            case .vertical:
                break
            case .horizontal:
                let frameOriginal = frame
                transform = CGAffineTransform(rotationAngle: -(.pi / 2))
                frame = CGRect(x: frameOriginal.origin.x - 50, y: frameOriginal.origin.y, width: frameOriginal.width + 100, height: frameOriginal.height)
            }
        }
    }
}
