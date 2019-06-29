//
//  TextHelper.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

class TextHelper {
    /**
     Highlights the matching search strings with the results

     Source: https://github.com/gm6379/MapKitAutocomplete

     - parameter text: The text to highlight
     - parameter ranges: The ranges where the text should be highlighted
     - parameter size: The size the text should be set at
     - returns: A highlighted attributed string with the ranges highlighted
     */
    static func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat, color: UIColor? = nil) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let regular = UIFont.systemFont(ofSize: size)
        attributedText.addAttribute(NSAttributedString.Key.font, value:regular, range:NSMakeRange(0, text.count))
        
        let bold = UIFont.boldSystemFont(ofSize: size)
        for value in ranges {
            attributedText.addAttribute(NSAttributedString.Key.font, value:bold, range:value.rangeValue)
            if let color = color {
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range:value.rangeValue)
            }
        }
        return attributedText
    }
}

