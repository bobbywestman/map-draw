//
//  ResizableView+Pan.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/23/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

extension ResizableView {
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        // TODO: change this to `if` & verify position when being manipulated
        // or use `boundingView ?? superView`
//        guard let boundingView = boundingView else {
//            return
//        }
        
        let location = recognizer.location(in: superview)
        self.location = location
        
        switch recognizer.state {
        case .began:
//            if topLeftCorner.contains(location) {
//                panning = .topLeft
//            } else if topRightCorner.contains(location) {
//                panning = .topRight
//            } else if bottomLeftCorner.contains(location) {
//                panning = .bottomLeft
//            } else if bottomRightCorner.contains(location) {
//                panning = .bottomRight
//            } else {
                panning = .center
//            }
        case .ended:
            panning = nil
        default:
            guard let panning = panning else {
                return
            }
            
            switch panning {
            case .center:
                // translate view while dragging
                let translation = recognizer.translation(in: superview)
                center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
                recognizer.setTranslation(CGPoint(x: 0, y: 0), in: superview)
            case .topLeft:
                // resize view while dragging corner
                
                // TODO: impl
                print("Panning selector view from corner: topLeft")
            case .topRight:
                // resize view while dragging corner
                
                // TODO: impl
                print("Panning selector view from corner: topRight")
            case .bottomRight:
                // resize view while dragging corner
                
                // TODO: impl
                print("Panning selector view from corner: bottomRight")
            case .bottomLeft:
                // resize view while dragging corner
                
                // TODO: impl
                print("Panning selector view from corner: bottomLeft")
            }
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
//        let topLeftPath = UIBezierPath(rect: convert(topLeftCorner, from: superview))
//        let topRightPath = UIBezierPath(rect: convert(topRightCorner, from: superview))
//        let bottomLeftPath = UIBezierPath(rect: convert(bottomLeftCorner, from: superview))
//        let bottomRightPath = UIBezierPath(rect: convert(bottomRightCorner, from: superview))
//
//        topLeftPath.close()
//        topRightPath.close()
//        bottomLeftPath.close()
//        bottomRightPath.close()
//
//        let fill = UIColor.red
//        fill.setFill()
//        topLeftPath.fill()
//        topRightPath.fill()
//        bottomRightPath.fill()
//        bottomLeftPath.fill()
//
//        guard let location = location else { return }
//        let point = convert(location, from: superview)
//        let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))
//        dotPath.close()
//        let dotFill = UIColor.blue
//        dotFill.setFill()
//        dotPath.fill()
    }
}
