//
//  CachedImage.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 01/11/2025.
//

import SwiftUI
import ImageIO
import MobileCoreServices

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

struct CachedImage: View {
    let url: URL
    let size: CGFloat
    
    @State private var uiImage: UIImage?
    @State private var isLoading = false
    @State private var loadFailed = false
    @State private var task: Task<Void, Never>?
    
    var body: some View {
        Group {
            if let img = uiImage {
                Image(uiImage: img).resizable().scaledToFill()
            } else if isLoading {
                ProgressView()
            } else if loadFailed {
                Image(systemName: "xmark.octagon.fill").resizable().scaledToFit()
            } else {
                Image(systemName: "photo").resizable().scaledToFit()
            }
        }
        .frame(width: size, height: size)
        .background(.accent.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task(id: url) { startLoad() } /// cancels previous when id changes
        .onDisappear { task?.cancel() }/// cancel when row goes off-screen
    }
    
    private func startLoad() {
        task?.cancel()
        task = Task {
            if let cached = await ImageCache.shared.image(for: url) {
                await MainActor.run { self.uiImage = cached; self.loadFailed = false }
                return
            }
            await MainActor.run { self.isLoading = true; self.loadFailed = false }
            defer { Task { @MainActor in self.isLoading = false } }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                // downsample to target size to save memory
                let maxDim = max(size, size)
                if let img = UIImage.downsampled(from: data, maxDimension: maxDim) {
                    let pixels = Int(img.size.width * img.scale * img.size.height * img.scale)
                    let cost = pixels * 4
                    await ImageCache.shared.set(img, for: url, cost: cost)
                    await MainActor.run { self.uiImage = img }
                } else {
                    await MainActor.run { self.loadFailed = true }
                }
            } catch is CancellationError {
                #if DEBUG
                print("Cancelled image load for \(url)")
                #endif
            } catch {
                await MainActor.run { self.loadFailed = true }
                #if DEBUG
                print("Image load failed for \(url): \(error.localizedDescription)")
                #endif
            }
        }
    }
}
