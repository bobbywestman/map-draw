//
//  ViewController+ColorPicker.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: ColorPickerDelegate {
    func colorDidChange(color: UIColor) {
        canvas.drawColor = color
        canvas.selectedLine = nil
        
        boxButton.backgroundColor = color.lighter().lighter()
        lineButton.backgroundColor = color.lighter().lighter()
        pinButton.backgroundColor = color.lighter().lighter()
        
        switch canvas.drawingState {
        case .box:
            boxButton.backgroundColor = color
        case .line:
            lineButton.backgroundColor = color
        case .pin:
            pinButton.backgroundColor = color
        case .none:
            break
        }
    }
}
