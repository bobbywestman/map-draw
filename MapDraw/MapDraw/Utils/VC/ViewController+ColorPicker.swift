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
        boxButton.tintColor = color
        lineButton.tintColor = color
        pinButton.tintColor = color
    }
}
