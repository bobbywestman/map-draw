//
//  ViewController.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/17/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var colorPicker: ColorPickerView!

    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var boxButton: UIButton!

    @IBOutlet weak var lineButton: UIButton!

    @IBOutlet weak var pinButton: UIButton!

    @IBOutlet weak var searchButton: UIButton!

    @IBOutlet weak var mapToggleButton: UIButton!

    @IBOutlet weak var saveButton: UIButton!
}

extension ViewController {
    override func viewDidLoad() {
        colorPicker.elementSize = 5
        colorPicker.delegate = self
        
        map.mapType = .satelliteFlyover
    }
}

extension ViewController: ColorPickerDelegate {
    func colorDidChange(color: UIColor) {
        boxButton.tintColor = color
        lineButton.tintColor = color
        pinButton.tintColor = color

        print(color)
    }
}

extension ViewController {
    @IBAction func boxButtonClick(_ sender: Any) {
        print("box")
    }
}

extension ViewController {
    @IBAction func lineButtonClick(_ sender: Any) {
        print("line")
    }
}

extension ViewController {
    @IBAction func pinButtonClick(_ sender: Any) {
        print("pin")
    }
}

extension ViewController {
    @IBAction func searchButtonClick(_ sender: Any) {
        print("search")
    }
}

extension ViewController {
    @IBAction func mapToggleButtonClick(_ sender: Any) {
        map.mapType = (map.mapType == .satelliteFlyover) ? .hybrid : .satelliteFlyover
    }
}

extension ViewController {
    @IBAction func saveButtonClick(_ sender: Any) {
        print("save")
    }
}
