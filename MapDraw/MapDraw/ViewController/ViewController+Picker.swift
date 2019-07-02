//
//  ViewController+Picker.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/27/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UIPickerViewDataSource {
    static let kPinLabelPickerNumberOfInts = 25
    static let kPinLabelPickerNumberOfAlphaCharacters = 26
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1 + ViewController.kPinLabelPickerNumberOfInts + ViewController.kPinLabelPickerNumberOfAlphaCharacters
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        drawingDelegate?.setPinLabel(getLabelForRow(row))
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // change color of selection indicators
        if pickerView.subviews.count > 2 {
            pickerView.subviews[1].backgroundColor = ViewController.dark
            pickerView.subviews[2].backgroundColor = ViewController.dark
        }
        
        let label = UILabel()
        label.text = getLabelForRow(row)
        label.textColor = ViewController.light
        label.textAlignment = .center
        label.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        return label
    }
    
    func getLabelForRow(_ row: Int) -> String {
        if row == 0 {
            return " "
        } else if row > 0, row < ViewController.kPinLabelPickerNumberOfInts + 1 {
            return "\(row)"
        } else {
            guard let characterIndex = UnicodeScalar(Int(UnicodeScalar("A").value) + (row - ViewController.kPinLabelPickerNumberOfInts - 1)) else {
                return " "
            }
            return "\(Character(characterIndex))"
        }
    }
    
    func getRowForLabel(_ label: String) -> Int? {
        if label == " " {
            return 0
        } else if let intValue = Int(label),
            intValue > 0,
            intValue < ViewController.kPinLabelPickerNumberOfInts + 1 {
            return intValue
        } else if let charValue = UnicodeScalar(label)?.value {
            return Int(charValue) - Int(UnicodeScalar("A").value) + ViewController.kPinLabelPickerNumberOfInts + 1
        } else {
            return nil
        }
    }
}
