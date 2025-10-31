//
//  PayTypeSheet.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI

struct PayTypeSheet: View {
    
    @Binding var selected: SaleType
    let onClose: () -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(SaleType.allCases, id: \.self) { type in
                    Button {
                        selected = type
                        onClose()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: type == selected ? "checkmark.circle.fill" : "circle")
                                .imageScale(.large)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(type.title).font(.headline)
                                Text(type.subtitle).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Select Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: onClose)
                }
            }
        }.presentationDetents([.height(550), .medium])
    }
}
