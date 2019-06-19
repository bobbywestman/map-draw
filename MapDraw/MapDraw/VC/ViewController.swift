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
    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var colorPicker: ColorPickerView!

    @IBOutlet weak var boxButton: UIButton!

    @IBOutlet weak var lineButton: UIButton!

    @IBOutlet weak var pinButton: UIButton!

    @IBOutlet weak var mapToggleButton: UIButton!

    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchResultsTableView: UITableView!

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!

    let completer = MKLocalSearchCompleter()

    var searchResults = [MKLocalSearchCompletion]() {
        didSet {
            guard searchResults.count > 0 else {
                searchResultsTableView.isHidden = true
                searchBar.resignFirstResponder
                searchBar.endEditing(true)
                return
            }
            searchResultsTableView.isHidden = false
            searchResultsTableView.reloadData()
            
            tableViewHeight.constant = 200
            searchResultsTableView.layoutIfNeeded()
            var height: CGFloat = 0.0
            for cell in searchResultsTableView.visibleCells {
                height += cell.frame.height
            }
            tableViewHeight.constant = min(200, height)
        }
    }
}

extension ViewController {
    override func viewDidLoad() {
        colorPicker.elementSize = 5
        colorPicker.delegate = self

        map.mapType = .hybridFlyover
        // TODO: set map center initially at current location

        searchBar.delegate = self

        completer.delegate = self
        // TODO: set completer.region based on current location?
        // Specifying a region does not guarantee that the results will all be inside the region. It is merely a hint to the search engine.

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.isHidden = true

//        searchResultsTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}

extension ViewController {
    @IBAction func boxButtonClick(_ sender: Any) {
        
    }
}

extension ViewController {
    @IBAction func lineButtonClick(_ sender: Any) {
        
    }
}

extension ViewController {
    @IBAction func pinButtonClick(_ sender: Any) {
        
    }
}

extension ViewController {
    @IBAction func mapToggleButtonClick(_ sender: Any) {
        map.mapType = (map.mapType == .satelliteFlyover) ? .hybridFlyover : .satelliteFlyover

        let text =  (mapToggleButton.titleLabel?.text == "Show Map Info") ? "Hide Map Info" : "Show Map Info"
        mapToggleButton.setTitle(text, for: .normal)
    }
}

extension ViewController {
    @IBAction func saveButtonClick(_ sender: Any) {
        let screenshot = ScreenshotHelper.screenshot(of: view, in: map.frame)

        let screenshotView = UIImageView(image: screenshot)
        screenshotView.translatesAutoresizingMaskIntoConstraints = false

        let alert = UIAlertController(title: "Save Screenshot", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { (action:UIAlertAction!) in
            ScreenshotHelper.saveImageToCameraRoll(screenshot)
        })
        alert.view.addSubview(screenshotView)

        // TODO: revisit this.. possibly create a custom alert vc
        // calculate height
        let height = CGFloat(125)
        // calculate aspect ratio of map
        let ratio = map.frame.width / map.frame.height
        // calculate width
        let width = ratio * height

        NSLayoutConstraint.activate([
            screenshotView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            screenshotView.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor),
            screenshotView.heightAnchor.constraint(equalToConstant: height),
            screenshotView.widthAnchor.constraint(equalToConstant: width),
        ])
        self.present(alert, animated: true, completion: nil)
    }
}
