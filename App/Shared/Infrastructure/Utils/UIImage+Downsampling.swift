//
//  UIImage+Downsampling.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 01/11/2025.
//

import UIKit
import ImageIO
import MobileCoreServices

extension UIImage {
    /// Create a downsampled image from raw `Data` to save memory.
    /// - Parameters:
    ///   - data: Raw image data.
    ///   - maxDimension: Target maximum dimension (points, not pixels).
    ///   - scale: Screen scale (default = main screen scale).
    /// - Returns: A downsampled `UIImage` or `nil` if decoding fails.
    static func downsampled(from data: Data,
                            maxDimension: CGFloat,
                            scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceShouldCacheImmediately: false
        ]
        guard let src = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) else {
            return nil
        }

        let maxPixel = Int(maxDimension * scale)
        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(src, 0, downsampleOptions as CFDictionary) else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}
