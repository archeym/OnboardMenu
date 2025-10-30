//
//  PayButtonSection.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

struct PayButtonSection: View {
    
    let name: String
    let baseEURPrice: Decimal
    @Binding var selectedCurrency: Currency
    let priceDisplay: (Decimal) async -> (primary: String, extras: [String])
    var onButtonPayTap: (() -> Void)? = nil

    @State private var displayText: (primary: String, extras: [String]) = ("", [])

    var body: some View {
        GeometryReader { geo in
            HStack {
                Button(action: {
                    onButtonPayTap?()
                }) {
                    HStack(spacing: 6) {
                        Text("\(name) \(displayText.primary)")
                            .font(.headline)
                            .lineLimit(1)

                        if !displayText.extras.isEmpty {
                            Text(displayText.extras.joined(separator: " or "))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(width: geo.size.width * 0.7)
                    .padding()
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadiusStyle(radius: 20, corners: [.bottomLeft, .topLeft])
                    
                }.buttonStyle(.plain)
            }
        }.frame(height: 35)
        .task {
            await recompute()
        }
        .onChange(of: selectedCurrency) { _, _ in
            Task {
                await recompute()
            }
        }
    }

    private func recompute() async {
        displayText = await priceDisplay(baseEURPrice)
    }
}
