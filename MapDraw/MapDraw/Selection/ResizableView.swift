//
//  ResizableView.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/22/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

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
    
    var panning: ResizableViewPanGestureLocation? = .center
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

