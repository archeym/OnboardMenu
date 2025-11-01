//
//  ImageCache.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 01/11/2025.
//

import SwiftUI

actor ImageCache {
    static let shared = ImageCache()
    
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 500 /// max items
        cache.totalCostLimit = 200 * 1024 * 1024 // ~200 MB
        return cache
    }()
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func set(_ image: UIImage, for url: URL, cost: Int) {
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
    
    func removeAll() { cache.removeAllObjects() }
}
