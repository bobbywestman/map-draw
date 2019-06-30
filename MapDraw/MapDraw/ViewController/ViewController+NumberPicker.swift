//
//  ViewController+NumberPicker.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/27/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 36
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        drawingDelegate?.setPinValue(row)
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
        label.text = getTextForRow(row)
        label.textColor = ViewController.light
        label.textAlignment = .center
        label.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        return label
    }
    
    func getTextForRow(_ row: Int) -> String{
        if row == 0 {
            return " "
        } else if row > 0, row < 10 {
            return "\(row)"
        } else {
            guard let characterIndex = UnicodeScalar(Int(UnicodeScalar("A").value) + (row - 10)) else {
                return " "
            }
            return "\(Character(characterIndex))"
        }
    }
}
