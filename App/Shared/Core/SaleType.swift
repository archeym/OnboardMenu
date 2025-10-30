//
//  SaleType.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 30/10/2025.
//

import SwiftUI
import Foundation

enum SaleType: String, CaseIterable, Equatable {
    
    case retail
    case crew
    case happyHour
    case businessInvitation
    case touristInvitation

    var title: String {
        switch self {
        case .retail: "Retail"
        case .crew: "Crew"
        case .happyHour: "Happy hour"
        case .businessInvitation: "Business invitation"
        case .touristInvitation: "Tourist invitation"
        }
    }

    var subtitle: String {
        switch self {
        case .retail: "Standard sale"
        case .crew: "Sale for cabin crew members"
        case .happyHour: "Special happy-hour sale"
        case .businessInvitation: "Special sale for business-class invitations"
        case .touristInvitation: "Special sale for economy-class invitations"
        }
    }
}
