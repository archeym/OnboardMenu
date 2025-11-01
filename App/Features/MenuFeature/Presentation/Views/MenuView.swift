//
//  MenuView.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI
import NetworkMonitor

struct MenuView: View {
    
    // Currency + formatting VM
    @StateObject var vm: MenuViewModel
    // Networking VM that loads the menu
    @StateObject var netVM: MenuNetworkingViewModel
    
    let merchantId: Int
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Group {
                    if let menus = netVM.menuResource.value {
                        let items = netVM.products(from: menus)
                        if items.isEmpty {
                            EmptyPlaceholderView(
                                systemImage: "cart",
                                title: "No products",
                                message: "Pull to refresh to try again."
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVGrid(columns: gridColumns, spacing: 12) {
                                    ForEach(items) { item in
                                        ProductCard(
                                            title: item.name,
                                            imageURL: item.photoURL,
                                            priceText: vm.priceTextForCardSync(eurPrice: item.eurPrice ?? 0),
                                            onMinus: { print("Minus \(item.name)") },
                                            onPlus:  { print("Plus \(item.name)")  }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 140)
                            }
                            .safeAreaInset(edge: .bottom) {
                                VStack(spacing: 8) {
                                    PayButtonSection(
                                        name: "PAY",
                                        baseEURPrice: 1,
                                        selectedCurrency: $vm.selectedCurrency,
                                        priceDisplay: { await vm.recomputeExtras(for: $0) },
                                        onButtonPayTap: { dump("onButtonPayTap") }
                                    )
                                    
                                    ExtraCurrencySection(
                                        baseEURPrice: 1,
                                        selectedCurrency: $vm.selectedCurrency,
                                        priceDisplay: { await vm.recomputeExtras(for: $0) }
                                    )
                                }
                                .padding(.horizontal)
                                .padding(.top, 8)
                                .background(.ultraThinMaterial)
                                .overlay(
                                    Divider().opacity(0.3),
                                    alignment: .top
                                )
                            }
                        }
                    } else {
                        if netVM.menuResource.isIdle {
                            EmptyPlaceholderView(
                                systemImage: "cart",
                                title: "No products yet",
                                message: "Pull to refresh to load products."
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                
                if netVM.menuResource.isLoading {
                    ProgressView("Loading")
                        .padding(20)
                        .background(.accent.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
                }
                
                if !networkMonitor.isConnected {
                    OfflineBannerSection()
                        .animation(.easeInOut(duration: 0.25), value: networkMonitor.isConnected)
                }
            }
            .disabled(!networkMonitor.isConnected)
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Error",
                isPresented: Binding(
                    get: { netVM.menuResource.error != nil && !(netVM.menuResource.error?.isCancelled ?? false) },
                    set: { presented in if !presented { netVM.clearError() } }
                )
            ) {
                Button("OK", role: .cancel) { netVM.clearError() }
            } message: {
                Text(netVM.menuResource.error?.userMessage ?? "")
            }
            .onChange(of: networkMonitor.isConnected) { _, isOn in
                if isOn, netVM.menuResource.value == nil {
                    Task {
                        await netVM.fetch(merchantId: merchantId)
                    }
                }
            }
            .task {
                await vm.warmRate(for: vm.selectedCurrency)
            }
            .task {
                if netVM.menuResource.isIdle {
                    await netVM.fetch(merchantId: merchantId)
                }
            }
            .refreshable {
                try? await Task.sleep(nanoseconds: 350_000_000)
                await netVM.fetch(merchantId: merchantId)
            }
        }
    }
}
