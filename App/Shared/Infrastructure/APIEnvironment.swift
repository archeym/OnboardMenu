//
//  APIEnvironment.swift
//  OnboardMenu
//
//  Created by Arkadijs Makarenko on 31/10/2025.
//

import SwiftUI

struct APIEnvironment {
    static var isProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }

    static let baseURL: URL = {
        var c = URLComponents()
        c.scheme = "https"
        c.host = isProduction ? "pie.up-co.com" : "pie.up-co.com"
        c.port = 3010
        guard let url = c.url else { preconditionFailure("Invalid base URL") }
        return url
    }()
}
