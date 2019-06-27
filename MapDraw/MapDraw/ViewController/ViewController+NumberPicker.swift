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
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // change color of selection indicators
        if pickerView.subviews.count > 2 {
            pickerView.subviews[1].backgroundColor = .white
            pickerView.subviews[2].backgroundColor = .white
        }
        
        let label = UILabel()
        label.text = "\(row)"
        label.textColor = .white
        label.textAlignment = .center
        label.transform = CGAffineTransform(rotationAngle: (.pi / 2))
        return label
    }
}