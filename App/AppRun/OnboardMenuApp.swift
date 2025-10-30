//
//  OnboardMenuApp.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI
import NetworkMonitor

@main
struct OnboardMenuApp: App {
    
    private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            DI.makeMenuView()
                .environmentObject(networkMonitor)
        }
    }
}
