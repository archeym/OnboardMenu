//
//  CachedFillBackground.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 01/11/2025.
//

import SwiftUI

///Full cached background that fills its parent
struct CachedFillBackground: View {
    let url: URL?

    var body: some View {
        GeometryReader { proxy in
            let dim = max(proxy.size.width, proxy.size.height)//target downsample size

            Group {
                if let url {
                    //Reuse your CachedImage loader, but sized to fill the parent
                    CachedImage(url: url, size: dim)
                        .frame(width: proxy.size.width, height: proxy.size.height) //stretch to parent
                        .clipped()
                } else {
                    Color.accent.opacity(0.15)
                }
            }
        }
    }
}

extension View {
    // Convenience for using the cached image as a card background
    func productCachedBackground(_ url: URL?) -> some View {
        background(CachedFillBackground(url: url))
    }
}
