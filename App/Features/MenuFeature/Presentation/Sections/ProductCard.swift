//
//  ProductCard.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

struct ProductCard: View {
    
    let title: String
    let imageURL: URL?
    let priceText: String
    let onMinus: () -> Void
    let onPlus: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .shadow(radius: 4)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            HStack(spacing: 5) {
                Button(action: onMinus) {
                    ZStack {
                        Circle().fill(Color.red)
                        Image(systemName: "minus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 34, height: 34)
                    .shadow(radius: 3)
                }

                Button(action: onPlus) {
                    ZStack {
                        Circle().fill(Color.blue)
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 34, height: 34)
                    .shadow(radius: 3)
                }

                Spacer(minLength: 0)

                Text(priceText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .shadow(radius: 3)
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
            .padding(8)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .aspectRatio(0.70, contentMode: .fit)// height is 1.7× width
        .background {
            if let url = imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    case .empty:
                        Color.gray.opacity(0.15)
                    case .failure:
                        Color.gray.opacity(0.25)
                    @unknown default:
                        Color.gray.opacity(0.15)
                    }
                }
                .transition(.opacity)
            } else {
                Color.gray.opacity(0.15)
            }
        }
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}
