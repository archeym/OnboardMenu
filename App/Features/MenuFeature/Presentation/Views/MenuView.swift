//
//  MenuView.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI
import NetworkMonitor

struct MenuView: View {
    @StateObject var vm: MenuViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @State private var isPickerVisible = false
    
    private let baseEURPrice: Decimal = Decimal(string: "3.50")!

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 16) {
                Spacer(minLength: 0)

                PayButtonSection(
                    name: "PAY",
                    baseEURPrice: baseEURPrice,
                    selectedCurrency: $vm.selectedCurrency,
                    priceDisplay: {
                        await vm.recomputeExtras(for: $0)
                    },
                    onButtonPayTap: { dump("onButtonPayTap") }
                )

                if isPickerVisible {
                    PickerSection(selectedCurrency: $vm.selectedCurrency)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                ExtraCurrencySection(
                    baseEURPrice: baseEURPrice,
                    selectedCurrency: $vm.selectedCurrency,
                    priceDisplay: { await vm.recomputeExtras(for: $0) },
                    onTap: {
                        withAnimation(.easeInOut) {
                            isPickerVisible.toggle()
                        }
                    }
                )
            }
            .disabled(!networkMonitor.isConnected)
            .padding(.horizontal)

            if !networkMonitor.isConnected {
                OfflineBannerSection()
                    .animation(.easeInOut(duration: 0.25), value: networkMonitor.isConnected)
            }
        }
    }
}
