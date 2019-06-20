//
//  ViewController+Drawing.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/20/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    @IBAction func boxButtonClick(_ sender: Any) {
        let arr = [CGPoint(x: 105, y: 105), CGPoint(x: 150, y: 150), CGPoint(x: 170, y: 150), CGPoint(x: 170, y: 105), CGPoint(x: 105, y: 105)]
        let color = UIColor.red
        
        let group = PointGroup(points: arr, color: color, path: nil)
        canvas.groups.append(group)
        canvas.setNeedsDisplay()
        
        let arr2 = [CGPoint(x: 400, y: 105), CGPoint(x: 600, y: 150), CGPoint(x: 400, y: 150), CGPoint(x: 400, y: 105)]
        let color2 = UIColor.blue
        
        let group2 = PointGroup(points: arr2, color: color2, path: nil)
        canvas.groups.append(group2)
        canvas.setNeedsDisplay()
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
    @IBAction func undoButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func redoButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        //        pointGroups = []
        //        updateDrawing()
    }
}
