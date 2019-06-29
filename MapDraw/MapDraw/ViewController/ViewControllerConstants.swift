//
//  ViewControllerConstants.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/28/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    static let dark = UIColor.gray
    static let light = UIColor.white
    static let darkTransparent = ViewController.dark.withAlphaComponent(0.3)
    static let darkMediumTransparent = ViewController.dark.withAlphaComponent(0.5)
    static let darkLessTransparent = ViewController.dark.withAlphaComponent(0.7)
    static let lightTransparent = ViewController.light.withAlphaComponent(0.3)
    static let lightMediumTransparent = ViewController.light.withAlphaComponent(0.5)
    static let lightLessTransparent = ViewController.light.withAlphaComponent(0.7)
    static let borderWidth = CGFloat(2)
    static let cornerRadius = CGFloat(15)
}
