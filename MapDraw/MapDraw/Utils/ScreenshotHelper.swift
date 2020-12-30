//
//  ScreenshotHelper.swift
//  MapDraw
//
//  Created by Bobby Westman on 6/18/19.
//  Copyright © 2019 Bobby Westman. All rights reserved.
//

import Foundation
import UIKit

class ScreenshotHelper {
    static func saveImageToCameraRoll(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

extension UIView {
    func screenshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let image = wholeImage, let rect = rect else { return wholeImage ?? UIImage() }

        guard let cgImage = image.cgImage?.cropping(to: rect * image.scale) else { return UIImage() }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
    }
}

extension CGRect {
    static func * (lhs: CGRect, rhs: CGFloat) -> CGRect {
        return CGRect(x: lhs.minX * rhs, y: lhs.minY * rhs, width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
