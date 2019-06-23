//
//  ColorPickerProtocols.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

protocol ColorPickerDelegate: class{
    func colorDidChange(color: UIColor)
}
