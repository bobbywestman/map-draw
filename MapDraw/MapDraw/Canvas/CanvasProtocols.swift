//
//  CanvasProtocols.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

protocol CanvasHandling: class {
    func drawingChanged(to state: DrawingState)
    func colorChanged(to color: UIColor)
}
