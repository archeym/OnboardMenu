//
//  EmptyPlaceholderView.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.6))

            Text(title)
                .font(.headline)
                .foregroundColor(.gray)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
