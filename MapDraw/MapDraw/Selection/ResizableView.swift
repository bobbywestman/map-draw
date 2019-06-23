//
//  ResizableView.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

enum SelectorPanGestureLocation {
    case center
    case topLeft
    case topRight
    case bottomright
    case bottomLeft
}

class ResizableView: UIView {
    /// View that this `ResizableView` is contained in. Used to calculate gesture locations.
    public var container: UIView?
    
    /// Aspect ratio the view must keep while rezing.
    public var aspectRatio: CGFloat? {
        didSet {
            guard let ratio = aspectRatio else {
                return
            }
            
            let height = frame.height
            let width = height * ratio
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var panning: SelectorPanGestureLocation? = .center
    var panningStartLocation: CGPoint?

    let cornerSize = CGFloat(30)
    let minSize = CGFloat(60)
    
    var topLeftCorner: CGRect {
        get {
            return CGRect(x: frame.minX, y: frame.minY, width: cornerSize, height: cornerSize);
        }
    }

    var topRightCorner: CGRect {
        get {
            return CGRect(x: frame.maxX - cornerSize, y: frame.minY, width: cornerSize, height: cornerSize);
        }
    }

    var bottomRightCorner: CGRect {
        get {
            return CGRect(x: frame.maxX - cornerSize, y: frame.maxY - cornerSize, width: cornerSize, height: cornerSize);
        }
    }

    var bottomLeftCorner: CGRect {
        get {
            return CGRect(x: frame.minX, y: frame.maxY - cornerSize, width: cornerSize, height: cornerSize);
        }
    }
}

extension ResizableView {
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        super.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
    }
}

extension ResizableView {
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: container ?? self)

        if recognizer.state == .began {
            if topLeftCorner.contains(location) {
                panning = .topLeft
            } else if topRightCorner.contains(location) {
                panning = .topRight
            } else if bottomLeftCorner.contains(location) {
                panning = .bottomLeft
            } else if bottomRightCorner.contains(location) {
                panning = .bottomright
            } else {
                panning = .center
            }
        } else if recognizer.state == .ended {
            panning = nil
        }

        guard let panning = panning, let container = container else {
            return
        }

        switch panning {
        case .center:
            // translate view while dragging
            let translation = recognizer.translation(in: container)
            center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero , in: container)
        case .topLeft:
            // resize view while dragging corner
            
            // TODO: impl
            print("left")
        case .topRight:
            // resize view while dragging corner

            // TODO: impl
            print("right")
        case .bottomright:
            // resize view while dragging corner

            // TODO: impl
            print("bottomRight")
        case .bottomLeft:
            // resize view while dragging corner

            // TODO: impl
            print("bottomLeft")
        }
    }
}

extension ResizableView {
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        let pinchScale: CGFloat = recognizer.scale
        transform = transform.scaledBy(x: pinchScale, y: pinchScale)
        recognizer.scale = 1.0
    }
    @objc func handleRotation(recognizer: UIRotationGestureRecognizer) {
        // TODO: Need to handle taking screenshots of rotates selection before enabling this
        
//        let rotation: CGFloat = recognizer.rotation
//        transform = transform.rotated(by: rotation)
//        recognizer.rotation = 0.0
    }
}

extension ResizableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
